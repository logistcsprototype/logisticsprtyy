class DriverWorkLog < ApplicationRecord
  belongs_to :driver
  belongs_to :vehicle
  belongs_to :admin

  validates :date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :total_hours, numericality: { greater_than: 0 }, allow_nil: true

  before_save :calculate_total_hours

  private

  def calculate_total_hours
    if start_time.present? && end_time.present?
      self.total_hours = ((end_time - start_time) / 3600.0).round(2)
    end
  end
end
