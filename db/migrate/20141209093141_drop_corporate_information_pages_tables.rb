class DropCorporateInformationPagesTables < ActiveRecord::Migration[4.2]
  def change
    drop_table :corporate_information_page_translations
    drop_table :corporate_information_pages
  end
end
