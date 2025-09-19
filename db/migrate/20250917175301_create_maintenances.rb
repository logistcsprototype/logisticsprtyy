class CreateMaintenances < ActiveRecord::Migration[8.0]
  def change
    create_table :maintenances do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.references :admin, null: false, foreign_key: true
      t.date :maintenance_date
      t.text :description
      t.decimal :cost
      t.date :next_due_date

      t.timestamps
    end
  end
end
