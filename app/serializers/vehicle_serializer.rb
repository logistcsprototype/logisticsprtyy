class VehicleSerializer < ActiveModel::Serializer
  attributes :id, :plate_number, :vehicle_type, :capacity, :passenger_capacity,
             :weight_capacity, :make, :model, :year, :color, :vin, :status,
             :created_at, :updated_at

  belongs_to :admin, serializer: AdminSerializer
  belongs_to :license_type
  has_many :driver_assignments
  has_many :maintenance_records, serializer: MaintenanceSerializer
  has_many :insurance_documents

  # Exclude sensitive fields if any
end
