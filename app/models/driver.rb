class Driver < ApplicationRecord
  belongs_to :license_type
  belongs_to :admin

  has_many :driver_assignments
  has_many :vehicles, through: :driver_assignments
  has_many :driver_work_logs
  has_many :driver_performances_reports

  validates :name, :license_number, :license_type_id, presence: true
  validates :license_number, uniqueness: true
  validates :age, numericality: { greater_than_or_equal_to: 18 }, allow_nil: true
  validates :gender, inclusion: { in: %w[Male Female]}, allow_nil: true


end
