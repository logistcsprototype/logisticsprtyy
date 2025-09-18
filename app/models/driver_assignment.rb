class DriverAssignment < ApplicationRecord
  belongs_to :driver
  belongs_to :vehicle
  belongs_to :admin

  validates :date_assigned, presence: true
  validates :vehicle_condition, presence: true
end
