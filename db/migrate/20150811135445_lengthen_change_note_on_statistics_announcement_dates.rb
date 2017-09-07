class LengthenChangeNoteOnStatisticsAnnouncementDates < ActiveRecord::Migration[4.2]
  def up
    change_column(:statistics_announcement_dates, :change_note, :text)
  end

  def down
    change_column(:statistics_announcement_dates, :change_note, :string)
  end
end
