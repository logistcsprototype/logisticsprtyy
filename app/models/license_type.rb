class LicenseType < ApplicationRecord
  has_many :drivers
  has_many :vehicles

  validates :code, presence: true, uniqueness: true
end
