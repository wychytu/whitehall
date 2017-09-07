class AddContentIdToOrganisation < ActiveRecord::Migration[4.2]
  def change
    add_column :organisations, :content_id, :string
    add_index :organisations, :content_id, unique: true
  end
end
