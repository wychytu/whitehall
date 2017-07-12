class AddAssetIdToAttachmentData < ActiveRecord::Migration
  def change
    add_column :attachment_data, :asset_id, :string
  end
end
