class AddContentIdToOperationalField < ActiveRecord::Migration[4.2]
  def change
    add_column :operational_fields, :content_id, :string
  end
end
