class DropGovernmentIdFromDocuments < ActiveRecord::Migration[4.2]
  def change
    remove_column :documents, :government_id
  end
end
