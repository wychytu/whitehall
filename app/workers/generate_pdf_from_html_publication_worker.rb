require 'net/http'

class GeneratePDFFromHtmlPublicationWorker
  class NotInContentStoreError < StandardError; end
  include Sidekiq::Worker

  # Possible race conditions if multiple publishers edit and save the same HTML
  # publication. We have no guarantee around which job will run first.
  def perform(attachment_id)
    Rails.logger.warn "Processing attachment #{attachment_id}"
    attachment = HtmlAttachment.find(attachment_id)
    Rails.logger.warn "Attachment: #{attachment.inspect}"

    return unless attachment.should_render_pdf

    # Fetch from content store
    item = Whitehall.content_store.content_item(attachment.url)
    Rails.logger.warn "Fetched from content store #{attachment.url}: #{item.inspect}"
    raise NotInContentStoreError if item.nil?

    # TODO: make it work in integration?
    # url = Plek.find('www') + attachment.url
    url = "https://www.gov.uk/government/publications/letters-of-direction-since-2004/letters-of-direction"
    html = open(url).read

    pdf = PDFKit.new(html)

    # Write the PDF data into an in-memory string
    io = StringIO.new
    io.write(pdf.to_pdf)
    io.rewind

    # Create a temp file with the PDF data
    file = Tempfile.new(['html_pub', '.pdf'], encoding: 'utf-8')
    file.write(io.read)
    Rails.logger.warn "Created temp file"

    uf = ActionDispatch::Http::UploadedFile.new(
      tempfile: file,
      filename: attachment.url.parameterize + '.pdf',
      content_type: AttachmentUploader::PDF_CONTENT_TYPE
    )

    new_attachment = FileAttachment.new(title: attachment.title)
    attachment_data = AttachmentData.new
    attachment_data.file = uf
    new_attachment.attachment_data = attachment_data
    new_attachment.attachable = attachment.attachable
    new_attachment.source_html_attachment = attachment

    new_attachment.save!
    Rails.logger.warn "Saved new attachment #{new_attachment.inspect}"


  end
end
