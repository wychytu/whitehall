class RemoveEditionsLocaleColumn < ActiveRecord::Migration[4.2]
  def change
    remove_column :editions, :locale
  end
end
