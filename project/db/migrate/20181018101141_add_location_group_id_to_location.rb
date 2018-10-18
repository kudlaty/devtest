class AddLocationGroupIdToLocation < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :location_group_id, :integer
  end
end
