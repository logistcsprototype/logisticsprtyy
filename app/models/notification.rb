class Notification < ApplicationRecord
  belongs_to :admin

  scope :unread, -> { where(read: false) }
end
