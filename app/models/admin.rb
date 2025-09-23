class Admin < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_many :vehicles
  has_many :drivers
  has_many :driver_assignments
  has_many :maintenance_records, class_name: 'Maintenance'
  has_many :driver_performance_reports
  has_many :insurance_documents
  has_many :notifications

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
