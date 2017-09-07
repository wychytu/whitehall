class AddContentIdToRoles < ActiveRecord::Migration[4.2]
  def change
    add_column :roles, :content_id, :string
  end
end
