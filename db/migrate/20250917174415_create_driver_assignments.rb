class CreateDriverAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :driver_assignments do |t|
      t.references :driver, null: false, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true
      t.references :admin, null: false, foreign_key: true
      t.date :date_assigned
      t.string :notes

      t.timestamps
    end
  end
end
