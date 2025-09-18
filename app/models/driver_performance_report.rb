class DriverPerformanceReport < ApplicationRecord
  belongs_to :driver
  belongs_to :admin
  belongs_to :vehicle, optional: true
  belongs_to :reported_by, class_name: 'Admin', optional: true

  validates :report_date, :rating, presence: true
  validates :comments, presence: true
  validates :performance_metrics, presence: true
end
