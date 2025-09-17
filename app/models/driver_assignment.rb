class DriverAssignment < ApplicationRecord
  belongs_to :driver
  belongs_to :vehicle
  belongs_to :admin

  validates :date_assigned, presence: true
end
