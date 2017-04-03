class AddPdfRenderedFromHtmlAttachmentIdToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :pdf_rendered_from_html_attachment_id, :integer
    add_index :attachments, :pdf_rendered_from_html_attachment_id
  end
end
