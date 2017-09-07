class DropPublishedRelatedPublicationCount < ActiveRecord::Migration[4.2]
  def change
    remove_column :editions, :published_related_publication_count
  end
end
