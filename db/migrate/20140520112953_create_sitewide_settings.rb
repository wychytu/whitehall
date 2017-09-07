class CreateSitewideSettings < ActiveRecord::Migration[4.2]
  def change
    create_table :sitewide_settings do |t|
      t.string :key, unique: true
      t.text :description
      t.boolean :on
      t.text :govspeak

      t.timestamps
    end
  end
end
