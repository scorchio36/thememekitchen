class User < ApplicationRecord

  MINIMUM_NAME_LENGTH = 6
  MAXIMUM_NAME_LENGTH = 30
  MAXIMUM_EMAIL_LENGTH = 255
  MINIMUM_PASSWORD_LENGTH = 6

  before_save { self.email = self.email.downcase }

  mount_uploader :picture, ProfilePicUploader

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed #following is the array of USERS that self is following
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower #followers is the array of USERS that self is being followed by #Allows us to say User.followers

  has_secure_password
  attr_accessor :remember_token

  validates :name, presence: true, length: {minimum: MINIMUM_NAME_LENGTH, maximum: MAXIMUM_NAME_LENGTH},
                                                              uniqueness: {case_sensitive: false}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: MAXIMUM_EMAIL_LENGTH},
                              format: {with: VALID_EMAIL_REGEX},
                                  uniqueness: {case_sensitive: false}
  validates :password, presence:true, length:{minimum: MINIMUM_PASSWORD_LENGTH}

  validate :picture_size



  #Session methods
  #give this method a string and it will return a hash using the BCrypt gem
  def User.digest(string)
   cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                 BCrypt::Engine.cost
   BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token

   SecureRandom.urlsafe_base64

  end

  def remember

   self.remember_token = User.new_token

   update_attribute(:remember_digest, User.digest(remember_token))

  end

 #like authenticate method for password but we are authenticating the users token with the hashed
  #token stored in the database
  def authenticate_token(remember_token)

    #Let's say a user has two different browsers open. In one browser, the user logs out. The other browser just gets
    #closed. When the user comes back to the second browser, the user_id cookie will still be in memory and the user
    #will be attempted to be pulled out of the db. This cannot happen though because the remember_digest of the user will
    #authenticate_token method when attempting to authenticate a user using conditionals, so we can just make the method
    #return false if the remember_digest is nil

    if remember_digest.nil?
      false
    else
      BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

  end

  #you dont have to nil the remember_token for the user because it will just get reassigned anyway
  def forget

    update_attribute(:remember_digest, nil)

  end






  #Post and comment functions
  #The following two functions are for pushing and removing liked post ID's from the User model
  def pushLikedPost(postID)

    posts = self.liked_posts
    posts.push(postID)
    update_attribute(:liked_posts, posts)

  end

  def removeLikedPost(postID)

    posts = self.liked_posts
    posts.delete(postID)
    update_attribute(:liked_posts, posts)

  end

  def pushDislikedPost(postID)

    posts = self.disliked_posts
    posts.push(postID)
    update_attribute(:disliked_posts, posts)

  end

  def removeDislikedPost(postID)

    posts = self.disliked_posts
    posts.delete(postID)
    update_attribute(:disliked_posts, posts)

  end




  #The following functions are just like the ones for pushing and removing liked posts from user arrays but they are for comments
  def pushLikedComment(commentID)

    comments = self.liked_comments
    comments.push(commentID)
    update_attribute(:liked_comments, comments)

  end

  def removeLikedComment(commentID)

    comments = self.liked_comments
    comments.delete(commentID)
    update_attribute(:liked_comments, comments)

  end

  def pushDislikedComment(commentID)

    comments = self.disliked_comments
    comments.push(commentID)
    update_attribute(:disliked_comments, comments)

  end

  def removeDislikedComment(commentID)

    comments = self.disliked_comments
    comments.delete(commentID)
    update_attribute(:disliked_comments, comments)

  end



  #functions for following
  def follow(other_user)
    active_relationship.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationship.find_by(id: other_user.id).destroy
  end

  def following?(other_user)
    self.following.include?(other_user) #this is possible from the has :through relationship we made
  end




  private

  def picture_size

    if picture.size > 5.megabytes

      errors.add(:picture, "should be less than 5MB")

    end

  end

end
