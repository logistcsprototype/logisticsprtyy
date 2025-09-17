# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_09_17_181127) do
  create_table "admins", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "driver_assignments", force: :cascade do |t|
    t.integer "driver_id", null: false
    t.integer "vehicle_id", null: false
    t.integer "admin_id", null: false
    t.date "date_assigned"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_driver_assignments_on_admin_id"
    t.index ["driver_id"], name: "index_driver_assignments_on_driver_id"
    t.index ["vehicle_id"], name: "index_driver_assignments_on_vehicle_id"
  end

  create_table "driver_performance_reports", force: :cascade do |t|
    t.integer "driver_id", null: false
    t.integer "admin_id", null: false
    t.date "report_date"
    t.integer "rating"
    t.text "comments"
    t.integer "vehicle_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_driver_performance_reports_on_admin_id"
    t.index ["driver_id"], name: "index_driver_performance_reports_on_driver_id"
    t.index ["vehicle_id"], name: "index_driver_performance_reports_on_vehicle_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.string "name"
    t.string "license_number"
    t.string "address"
    t.integer "years_experience"
    t.integer "age"
    t.string "gender"
    t.integer "license_type_id", null: false
    t.integer "admin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_drivers_on_admin_id"
    t.index ["license_type_id"], name: "index_drivers_on_license_type_id"
  end

  create_table "insurance_documents", force: :cascade do |t|
    t.integer "vehicle_id", null: false
    t.integer "admin_id", null: false
    t.string "document_type"
    t.date "expiry_date"
    t.string "document_url"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_insurance_documents_on_admin_id"
    t.index ["vehicle_id"], name: "index_insurance_documents_on_vehicle_id"
  end

  create_table "license_types", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "maintenances", force: :cascade do |t|
    t.integer "vehicle_id_id", null: false
    t.integer "admin_id", null: false
    t.date "maintenance_date"
    t.text "description"
    t.decimal "cost"
    t.date "next_due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_maintenances_on_admin_id"
    t.index ["vehicle_id_id"], name: "index_maintenances_on_vehicle_id_id"
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "plate_number"
    t.string "vehicle_type"
    t.integer "capacity"
    t.string "owner_type"
    t.string "owner_name"
    t.integer "license_type_id", null: false
    t.integer "admin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_vehicles_on_admin_id"
    t.index ["license_type_id"], name: "index_vehicles_on_license_type_id"
  end

  add_foreign_key "driver_assignments", "admins"
  add_foreign_key "driver_assignments", "drivers"
  add_foreign_key "driver_assignments", "vehicles"
  add_foreign_key "driver_performance_reports", "admins"
  add_foreign_key "driver_performance_reports", "drivers"
  add_foreign_key "driver_performance_reports", "vehicles"
  add_foreign_key "drivers", "admins"
  add_foreign_key "drivers", "license_types"
  add_foreign_key "insurance_documents", "admins"
  add_foreign_key "insurance_documents", "vehicles"
  add_foreign_key "maintenances", "admins"
  add_foreign_key "maintenances", "vehicle_ids"
  add_foreign_key "vehicles", "admins"
  add_foreign_key "vehicles", "license_types"
end
