class AddContentIdToWorldLocations < ActiveRecord::Migration[4.2]
  def change
    add_column :world_locations, :content_id, :string
  end
end
