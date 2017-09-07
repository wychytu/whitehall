class AddIsDeletedToAttachments < ActiveRecord::Migration[4.2]
  def change
    add_column :attachments, :deleted, :boolean, null: false, default: false
  end
end
