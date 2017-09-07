class CreateFeaturedPolicies < ActiveRecord::Migration[4.2]
  def change
    create_table :featured_policies do |t|
      t.string :policy_content_id
      t.integer :ordering, null: false
      t.references :organisation
    end
  end
end
