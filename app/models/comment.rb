class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :comment, length: {minimum: 1, maximum: 175}, presence: true

  default_scope -> {order(created_at: :desc)}


  def liked_by(user)
      user.liked_comments.include?(self.id)
  end

  def disliked_by(user)
      user.disliked_comments.include?(self.id)
  end

end
