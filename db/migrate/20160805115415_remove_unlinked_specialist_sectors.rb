class RemoveUnlinkedSpecialistSectors < ActiveRecord::Migration[4.2]
  def up
    SpecialistSector.delete_all edition_id: nil
  end

  def down
    # We can't undo deleting data in the migration
  end
end
