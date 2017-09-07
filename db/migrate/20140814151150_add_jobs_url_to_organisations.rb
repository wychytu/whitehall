class AddJobsUrlToOrganisations < ActiveRecord::Migration[4.2]
  def change
    add_column :organisations, :custom_jobs_url, :string
  end
end
