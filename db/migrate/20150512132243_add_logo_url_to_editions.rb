class AddLogoUrlToEditions < ActiveRecord::Migration[4.2]
  def change
    add_column :editions, :logo_url, :string
  end
end
