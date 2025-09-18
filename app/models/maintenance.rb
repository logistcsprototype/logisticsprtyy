class Maintenance < ApplicationRecord
  belongs_to :vehicle
  belongs_to :admin

  validates :maintenance_date, :description, presence: true
end
