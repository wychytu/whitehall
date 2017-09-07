class AddContentIdToAboutPage < ActiveRecord::Migration[4.2]
  def change
    add_column :about_pages, :content_id, :string
  end
end
