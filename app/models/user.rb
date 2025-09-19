class User < ApplicationRecord

  has_secure_password

  validates :email, presence:true, uniqueness: true
  validates :name, presence: true
  validates :role, presence: true, inclusion: { in: %w[admin driver vehicleManager] }
  
end
