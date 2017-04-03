class AddShouldRenderPdfToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :should_render_pdf, :boolean
  end
end
