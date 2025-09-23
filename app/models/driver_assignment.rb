class DriverAssignment < ApplicationRecord
  belongs_to :driver
  belongs_to :vehicle
  belongs_to :admin

  enum assignment_status: { active: 0, inactive: 1, completed: 2 }

  validates :date_assigned, presence: true
  validates :vehicle_condition, presence: true
  validates :assignment_status, presence: true
  validates :end_date, presence: true, if: -> { assignment_status == "completed" }
end
