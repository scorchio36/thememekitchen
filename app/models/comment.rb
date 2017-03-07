class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :comment, length: {minimum: 1, maximum: 255}, presence: true, allow_blank: false

  default_scope -> {order(likes: :desc)}


  def liked_by(user)
      user.liked_comments.include?(self.id)
  end

  def disliked_by(user)
      user.disliked_comments.include?(self.id)
  end

end
