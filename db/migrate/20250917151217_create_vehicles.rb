class CreateVehicles < ActiveRecord::Migration[8.0]
  def change
    create_table :vehicles do |t|
      t.string :plate_number
      t.string :vehicle_type
      t.integer :capacity
      t.string :owner_type
      t.string :owner_name
      t.references :license_type, null: false, foreign_key: true
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
