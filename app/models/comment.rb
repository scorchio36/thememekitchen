class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :comment, length: {minimum: 1, maximum: 175}, presence: true

  default_scope -> {order(created_at: :desc)}

end
