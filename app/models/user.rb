class User < ApplicationRecord

  before_save { self.email = self.email.downcase }

  has_secure_password
  attr_accessor :remember_token


  validates :name, presence: true, length: {minimum: 6, maximum: 30},
                                                              uniqueness: {case_sensitive: false}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
                              format: {with: VALID_EMAIL_REGEX},
                                  uniqueness: {case_sensitive: false}

  validates :password, presence:true, length:{minimum: 6}





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
    #be nil because the user was logged out of the first browser (which makes the digest nil). We use this
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


end
