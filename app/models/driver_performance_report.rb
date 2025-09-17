class DriverPerformanceReport < ApplicationRecord
  belongs_to :driver
  belongs_to :admin
  belongs_to :vehicle, optional: true

  validates :report_date, :rating, presence: true
end
