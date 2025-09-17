class CreateInsuranceDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :insurance_documents do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.references :admin, null: false, foreign_key: true
      t.string :document_type
      t.date :expiry_date
      t.string :document_url
      t.text :notes

      t.timestamps
    end
  end
end
