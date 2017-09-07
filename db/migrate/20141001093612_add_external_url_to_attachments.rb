class AddExternalUrlToAttachments < ActiveRecord::Migration[4.2]
  def change
    add_column :attachments, :external_url, :string
  end
end
