class Admin < ApplicationRecord
  has_secure_password

  has_many :vehicles
  has_many :drivers
  has_many :driver_assignments
  has_many :maintenance_records, class_name: 'Maintenance'
  has_many :driver_performances_reports
  has_many :insurance_documents

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true


end
