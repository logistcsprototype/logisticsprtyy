class Maintenance < ApplicationRecord
  belongs_to :vehicle_id
  belongs_to :admin

  validates :maintenance_date, :description, presence: true
end
