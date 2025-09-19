class Maintenance < ApplicationRecord
  belongs_to :vehicle
  belongs_to :admin

  enum maintenance_type: { tires: 0, oil: 1, inspection: 2, brake: 3, battery: 4, engine: 5, transmission: 6, other: 7 }

  validates :maintenance_date, :description, presence: true
  validates :maintenance_type, presence: true
  validates :next_due_date, presence: true
  validates :mileage_at_service, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :service_provider, presence: true
end
