class AddColumnGovernmentToDocument < ActiveRecord::Migration[4.2]
  def change
    add_column :documents, :government_id, :integer
  end
end
