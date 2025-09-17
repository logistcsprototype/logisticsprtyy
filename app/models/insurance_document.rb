class InsuranceDocument < ApplicationRecord
  belongs_to :vehicle
  belongs_to :admin

  validates :document_type, :expiry_date, presence: true
end
