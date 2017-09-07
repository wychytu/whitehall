class DisallowNullsInSpecialistSectors < ActiveRecord::Migration[4.2]
  def change
    change_column_null :specialist_sectors, :edition_id, false
    change_column_null :specialist_sectors, :tag, false
  end
end
