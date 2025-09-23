class MaintenanceSerializer < ActiveModel::Serializer
  attributes :id, :maintenance_type, :description, :scheduled_date, :performed_date,
             :cost, :status, :notes, :created_at, :updated_at

  belongs_to :vehicle
  belongs_to :admin
end