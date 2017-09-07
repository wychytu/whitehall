class RemoveDetailedGuideCategories < ActiveRecord::Migration[4.2]
  def up
    drop_table :edition_mainstream_categories
    drop_table :organisation_mainstream_categories
    drop_table :mainstream_categories
    remove_column :editions, :primary_mainstream_category_id
  end
end
