class CreateDriverWorkLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :driver_work_logs do |t|
      t.references :driver, null: false, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true
      t.references :admin, null: false, foreign_key: true
      t.date :date, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.decimal :total_hours, precision: 5, scale: 2

      t.timestamps
    end
  end
end