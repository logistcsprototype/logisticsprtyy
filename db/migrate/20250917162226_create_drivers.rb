class CreateDrivers < ActiveRecord::Migration[8.0]
  def change
    create_table :drivers do |t|
      t.string :name
      t.string :license_number
      t.string :address
      t.integer :years_experience
      t.integer :age
      t.string :gender
      t.references :license_type, null: false, foreign_key: true
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
