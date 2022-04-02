class Relationship < ApplicationRecord
  belongs_to :followed, class_name: "User"
  belongs_to :follower, class_name: "User"
  #Relationshipモデルのfollowed_idとUserクラスのidが紐づいている
  validates :follower_id, presence:true
  validates :followed_id, presence:true
end
