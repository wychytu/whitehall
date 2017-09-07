class AddPoliticalToEditions < ActiveRecord::Migration[4.2]
  def change
    add_column :editions, :political, :boolean, default: false
  end
end
