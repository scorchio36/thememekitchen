class Post < ApplicationRecord


  MAXIMUM_TITLE_LENGTH = 40
  MAXIMUM_DESCRIPTION_LENGTH = 300

  belongs_to :user
  has_many :comments, dependent: :destroy
  mount_uploader :picture, PictureUploader

  default_scope -> {order(created_at: :desc)}

  validates :title, presence: true, length: {maximum: MAXIMUM_TITLE_LENGTH}
  validates :description, length: {maximum: MAXIMUM_DESCRIPTION_LENGTH}
  validates :picture, presence: true
  validate :picture_size




  def liked_by(user)
      if !(user.nil?)
        user.liked_posts.include?(self.id)
      end
  end

  def disliked_by(user)
      if !(user.nil?)
        user.disliked_posts.include?(self.id)
      end
  end

  def toggle_main_course

    if self.main_course?

      self.update_attribute(:main_course, false)

    else

      self.update_attribute(:main_course, true)
      self.update_attribute(:main_course_added_at, Time.now)

    end

  end


#ensures that the uploaded picture is not too large
  private

  def picture_size

    if picture.size > 5.megabytes

      errors.add(:picture, "should be less than 5MB")

    end

  end

  #return true if the post is liked by the given user

  #return true if the post if disliked by the given user
  #def disliked_by(user)

    #user.

  #end

end
