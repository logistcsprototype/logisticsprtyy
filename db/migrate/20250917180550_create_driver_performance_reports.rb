class CreateDriverPerformanceReports < ActiveRecord::Migration[8.0]
  def change
    create_table :driver_performance_reports do |t|
      t.references :driver, null: false, foreign_key: true
      t.references :admin, null: false, foreign_key: true
      t.date :report_date
      t.integer :rating
      t.text :comments
      t.references :vehicle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
