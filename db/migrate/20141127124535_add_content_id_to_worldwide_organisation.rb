class AddContentIdToWorldwideOrganisation < ActiveRecord::Migration[4.2]
  def change
    add_column :worldwide_organisations, :content_id, :string
  end
end
