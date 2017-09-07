class DropDefaultRoleType < ActiveRecord::Migration[4.2]
  def change
    change_column_default("roles", "type", nil)
  end
end
