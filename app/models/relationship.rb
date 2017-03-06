class Relationship < ApplicationRecord

  #followed is the person in the relationship being followed
  #follower is the person in the relationship doing the following
  belongs_to :follower, class_name: "User" #Ex: if I said active_relationship.follower its like a different version of saying Relationship.User
  belongs_to :followed, class_name: "User"

end
