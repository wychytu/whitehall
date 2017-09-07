class DeleteEditionMinisterialRole < ActiveRecord::Migration[4.2]
  def change
    drop_table :edition_ministerial_roles
  end
end
