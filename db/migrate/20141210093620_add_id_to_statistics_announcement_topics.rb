class AddIdToStatisticsAnnouncementTopics < ActiveRecord::Migration[4.2]
  def change
    add_column :statistics_announcement_topics, :id, :primary_key
  end
end
