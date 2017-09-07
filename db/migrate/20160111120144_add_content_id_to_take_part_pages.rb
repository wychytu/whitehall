class AddContentIdToTakePartPages < ActiveRecord::Migration[4.2]
  def change
    add_column :take_part_pages, :content_id, :string
  end
end
