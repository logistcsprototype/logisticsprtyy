class AddNextMaintenanceDateToVehicles < ActiveRecord::Migration[8.0]
  def change
    add_column :vehicles, :next_maintenance_date, :date
  end
end
