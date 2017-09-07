class AddContentIdToDocument < ActiveRecord::Migration[4.2]
  def change
    add_column :documents, :content_id, :string
  end
end
