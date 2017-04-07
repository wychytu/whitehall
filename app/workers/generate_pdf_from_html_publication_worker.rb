require 'net/http'

class GeneratePdfFromHtmlPublicationWorker
# Given an HTML Attachment ID, this worker will:
# 1. Fetch the fully-rendered HTML Attachment (complete with CSS) from government-frontend via HTTP
# 2. Render this HTML as a PDF
# 3. Add the PDF attachment to the Edition
# 4. Republish the Edition so that the PDF is displayed on government-frontend
#
# Since this worker is kicked off when an Edition is (re)published, and we republish
# the Edition at the end of the process, this process has the potential to cause an
# infinite loop of publishing. Hence, we hash the HTML that was used to render the PDF
# and store it in the PDF filename. If a PDF with this hash in its filename already exists,
# then we have already generated a PDF for the given HTML, so we can simply return from
# the worker, and break the loop.
  class NotInContentStoreError < StandardError; end
  include Sidekiq::Worker

  sidekiq_options queue: 'generate_pdf_from_html_publication'

  def perform(html_attachment_id)
    Rails.logger.warn "Processing attachment #{html_attachment_id}"
    html_attachment = HtmlAttachment.find(html_attachment_id)
    Rails.logger.warn "Attachment: #{html_attachment.inspect}"

    return unless html_attachment.should_render_pdf

    html = fetch_rendered_html_for(html_attachment)
    pdf_filename = pdf_filename_for(html_attachment)

    return if AttachmentData.exists?(carrierwave_file: pdf_filename)

    pdf_file = PdfService.render_html_as_pdf(html)
    uploaded_pdf = PdfService.upload_pdf(pdf_file, pdf_filename)
    pdf_attachment = PdfService.attach_pdf_next_to_html_attachment(uploaded_pdf, html_attachment)

    document_id = pdf_attachment.attachable.document_id
    republish_document(document_id)
  end

  def fetch_rendered_html_for(html_attachment)
    html_attachment_content_item = Whitehall.content_store.content_item(html_attachment.url)
    Rails.logger.warn "Fetched from content store #{html_attachment.url}: #{html_attachment_content_item.inspect}"
    raise NotInContentStoreError if html_attachment_content_item.nil?

    # TODO: make it work in integration?
    # url = Plek.find('www') + attachment.url
    url = "https://www.gov.uk/government/publications/letters-of-direction-since-2004/letters-of-direction"
    # TODO: Check "updated_at" dates to make sure we've fetched the latest version of the HTML?
    open(url).read
  end

  def pdf_filename_for(html_attachment)
    html_hash = html_attachment.govspeak_content.body_html.hash
    "#{html_attachment.url.parameterize}-#{html_hash}.pdf"
  end

  def republish_document(document_id)
    PublishingApiDocumentRepublishingWorker.new.perform(document_id)
  end
end
