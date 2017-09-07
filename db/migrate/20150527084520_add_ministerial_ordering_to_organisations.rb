class AddMinisterialOrderingToOrganisations < ActiveRecord::Migration[4.2]
  def change
    add_column :organisations, :ministerial_ordering, :integer
  end
end
