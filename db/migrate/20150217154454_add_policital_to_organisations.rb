class AddPolicitalToOrganisations < ActiveRecord::Migration[4.2]
  def change
    add_column :organisations, :political, :boolean, default: false
  end
end
