class AddMetadataFieldsToAttachments < ActiveRecord::Migration[4.2]
  def change
    add_column :attachments, :print_meta_data_contact_address, :string
  end
end
