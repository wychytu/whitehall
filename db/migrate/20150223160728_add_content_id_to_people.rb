class AddContentIdToPeople < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :content_id, :string
  end
end
