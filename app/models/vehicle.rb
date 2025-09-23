class Vehicle < ApplicationRecord
  belongs_to :license_type
  belongs_to :admin

  has_many :driver_assignments
  has_many :drivers, through: :driver_assignments
  has_many :maintenance_records, class_name: "Maintenance"
  has_many :insurance_documents

  validates :plate_number, presence: true, uniqueness: true
  validates :vehicle_type, presence: true
  validates :passenger_capacity, numericality: { greater_than_or_equal_to: 1 }, allow_nil: true
  validates :weight_capacity, numericality: { greater_than: 0 }, allow_nil: true

  # Owner info: 'self' or 'third_party'
  validates :owner_type, presence: true, inclusion: { in: %w[self third_party] }
  validates :owner_name, presence: true
end
