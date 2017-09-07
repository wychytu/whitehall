class AddContentIdToStatisticsAnnouncements < ActiveRecord::Migration[4.2]
  def change
    add_column :statistics_announcements, :content_id, :string, null: false
  end
end
