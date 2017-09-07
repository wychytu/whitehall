class DropFeaturedServicesAndGuidanceAndTopTasks < ActiveRecord::Migration[4.2]
  def up
    drop_table :featured_services_and_guidance
    drop_table :top_tasks
  end
end
