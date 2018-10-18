class CreateTargetGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :target_groups do |t|
      t.string :name
      t.integer :external_id
      t.integer :parent_id
      t.string :secret_code
      t.integer :panel_provider_id
      t.timestamps
    end
  end
end
