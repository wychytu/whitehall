class CreateClassificationPolicies < ActiveRecord::Migration[4.2]
  def change
    create_table :classification_policies do |t|
      t.references :classification
      t.string :policy_content_id
      t.timestamps
    end

    add_index :classification_policies, :classification_id
    add_index :classification_policies, :policy_content_id
  end
end
