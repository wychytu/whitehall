class RemoveNeedIdsFromEditions < ActiveRecord::Migration[4.2]
  def change
    remove_column :editions, :need_ids, :string
  end
end
