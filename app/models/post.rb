class Post < ApplicationRecord



  MAXIMUM_TITLE_LENGTH = 50
  MAXIMUM_DESCRIPTION_LENGTH = 300

  belongs_to :user

  default_scope -> {order(created_at: :desc)}

  validates :title, presence: true, length: {maximum: MAXIMUM_TITLE_LENGTH}
  validates :description, length: {maximum: MAXIMUM_DESCRIPTION_LENGTH}


end
