class RemoveBodyFromAttachements < ActiveRecord::Migration[4.2]
  def change
    remove_columns :attachments, :body, :manually_numbered_headings
  end
end
