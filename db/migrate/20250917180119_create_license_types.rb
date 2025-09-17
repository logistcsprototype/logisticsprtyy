class CreateLicenseTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :license_types do |t|
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end
