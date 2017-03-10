class Notification < ApplicationRecord
  belongs_to :user

  MAXIMUM_DESCRIPTION_LENGTH = 255

  default_scope -> {order(created_at: :desc)}

  validates :description, length: {maximum: MAXIMUM_DESCRIPTION_LENGTH}
end
