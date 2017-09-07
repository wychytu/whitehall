class AddContentIdToClassifications < ActiveRecord::Migration[4.2]
  def change
    add_column :classifications, :content_id, :string
  end
end
