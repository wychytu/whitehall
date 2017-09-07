class AddWebIsbnToAttachments < ActiveRecord::Migration[4.2]
  def change
    add_column :attachments, :web_isbn, :string
  end
end
