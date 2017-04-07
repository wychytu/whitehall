require 'net/http'

class GeneratePdfFromHtmlPublicationWorker
  class NotInContentStoreError < StandardError; end
  include Sidekiq::Worker

  sidekiq_options queue: 'generate_pdf_from_html_publication'

  # Possible race conditions if multiple publishers edit and save the same HTML
  # publication. We have no guarantee around which job will run first.
  def perform(attachment_id)
    Rails.logger.warn "Processing attachment #{attachment_id}"
    html_attachment = HtmlAttachment.find(attachment_id)
    Rails.logger.warn "Attachment: #{html_attachment.inspect}"

    return unless html_attachment.should_render_pdf

    # Fetch from content store
    item = Whitehall.content_store.content_item(html_attachment.url)
    Rails.logger.warn "Fetched from content store #{html_attachment.url}: #{item.inspect}"
    raise NotInContentStoreError if item.nil?

    # TODO: make it work in integration?
    # url = Plek.find('www') + attachment.url
    url = "https://www.gov.uk/government/publications/letters-of-direction-since-2004/letters-of-direction"
    html = open(url).read

    # Until we can render the PDF prior to publishing, we have to:
    # 1. Publish HTML Attachment
    # 2. Fetch fully-rendered HTML Attachment from government-frontend via HTTP
    # 3. Render this as a PDF
    # 4. Add the PDF attachment to the Edition
    # 5. Re-publish the edition so that the PDF is displayed on government-frontend
    #
    # This process has the potential to cause an infinite loop of publishing. Hence,
    # we hash the HTML that was used to render the PDF and store it in the PDF filename.
    # If a PDF with this hash in its filename already exists, then we have already
    # generated a PDF for the given HTML, so we can simply return from the worker, and
    # break the loop.
    html_hash = html.hash
    pdf_filename = "#{html_attachment.url.parameterize}-#{html_hash}.pdf"

    return if AttachmentData.exists?(carrierwave_file: pdf_filename)

    # If we don't set the viewport size, the headless browser renders mobile breakpoint
    # styling
    pdf = PDFKit.new(html, viewport_size: '1280x1024')

    # Write the PDF data into an in-memory string
    io = StringIO.new
    io.write(pdf.to_pdf)
    io.rewind
    pdf_string = io.read

    # Create a temp file with the PDF data
    file = Tempfile.new(['html_pub', '.pdf'], encoding: 'utf-8')
    file.write(pdf_string)
    Rails.logger.warn "Created temp file"

    uf = ActionDispatch::Http::UploadedFile.new(
      tempfile: file,
      filename: pdf_filename,
      content_type: AttachmentUploader::PDF_CONTENT_TYPE,
    )

    pdf_attachment = FileAttachment.new(title: html_attachment.title)
    pdf_attachment_data = AttachmentData.new
    pdf_attachment_data.file = uf
    pdf_attachment.attachment_data = pdf_attachment_data
    pdf_attachment.attachable = html_attachment.attachable
    pdf_attachment.source_html_attachment = html_attachment

    pdf_attachment.save!
    Rails.logger.warn "Saved new attachment #{pdf_attachment.inspect}"

    document_id = pdf_attachment.attachable.document_id
    PublishingApiDocumentRepublishingWorker.new.perform(document_id)
  end
end
