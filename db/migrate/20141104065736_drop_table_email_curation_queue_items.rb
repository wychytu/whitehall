class DropTableEmailCurationQueueItems < ActiveRecord::Migration[4.2]
  def up
    drop_table :email_curation_queue_items
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
