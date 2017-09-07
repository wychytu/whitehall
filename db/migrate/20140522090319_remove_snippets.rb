class RemoveSnippets < ActiveRecord::Migration[4.2]
  def change
    drop_table :snippets
  end
end
