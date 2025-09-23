class InsuranceDocument < ApplicationRecord
  belongs_to :vehicle
  belongs_to :admin

  validates :document_type, :expiry_date, presence: true

  scope :expiring_soon, -> { where("expiry_date <= ?", 30.days.from_now) }
  scope :expired, -> { where("expiry_date < ?", Date.current) }

  def expiring_soon?
    expiry_date <= 30.days.from_now
  end

  def expired?
    expiry_date < Date.current
  end
end
