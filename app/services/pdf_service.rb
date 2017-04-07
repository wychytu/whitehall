require 'net/http'

class PdfService
  class << self
    # Given an HTML string, renders the HTML as a PDF, and saves the PDF to a Tempfile,
    # which it returns
    def render_html_as_pdf(html)
      pdf_string = render_html_as_pdf_string(html)
      save_pdf_string_to_temp_file(pdf_string)
    end

    def upload_pdf(file, filename)
      ActionDispatch::Http::UploadedFile.new(
        tempfile: file,
        filename: filename,
        content_type: AttachmentUploader::PDF_CONTENT_TYPE,
      )
    end

    def attach_pdf_next_to_html_attachment(uploaded_pdf, html_attachment)
      pdf_attachment = FileAttachment.new(title: html_attachment.title)
      pdf_attachment_data = AttachmentData.new
      pdf_attachment_data.file = uploaded_pdf
      pdf_attachment.attachment_data = pdf_attachment_data
      pdf_attachment.attachable = html_attachment.attachable
      pdf_attachment.source_html_attachment = html_attachment

      pdf_attachment.save!
      Rails.logger.warn "Saved new attachment #{pdf_attachment.inspect}"

      pdf_attachment
    end

    # Given an HTML string, renders the HTML as a PDF, and returns the resulting stream
    # of bytes as a String
    def render_html_as_pdf_string(html)
      # If we don't set the viewport size, the headless browser renders mobile breakpoint
      # styling, so force it to desktop width
      pdf_kit = PDFKit.new(html, viewport_size: '1280x1024')

      pdf_io = StringIO.new
      pdf_io.write(pdf_kit.to_pdf)
      pdf_io.rewind
      pdf_io.read
    end

    # Given a PDF as a String, saves the String to a Tempfile, which is returned
    def save_pdf_string_to_temp_file(pdf_string)
      file = Tempfile.new(%w(html_pub .pdf), encoding: 'utf-8')
      file.write(pdf_string)
      Rails.logger.warn "Created temp file"
      file
    end
  end

  private_class_method :render_html_as_pdf_string
  private_class_method :save_pdf_string_to_temp_file

  class NotInContentStoreError < StandardError; end
end
