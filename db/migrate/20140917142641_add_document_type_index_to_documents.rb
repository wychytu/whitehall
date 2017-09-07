class AddDocumentTypeIndexToDocuments < ActiveRecord::Migration[4.2]
  def change
    add_index :documents, :document_type
  end
end
