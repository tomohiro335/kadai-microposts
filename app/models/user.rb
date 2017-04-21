class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :microposts
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  has_many :favs
#  has_many :microposts, through: :favs, source: :microposts
  has_many :favoritings, through: :favs, source: :micropost
  
  def follow(other_user)
    unless self == other_user
    self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end
  
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  # targetをファボる
  def favorite(target_micropost)
    #一件目を参照、なかったら作る
    self.favs.find_or_create_by(micropost_id: target_micropost.id)
  end
  
  # アンファボ
  def unfavorite(target_micropost)
    fav = self.favs.find_by(micropost_id: target_micropost.id)
    fav.destroy if fav
#    fav.destroy if fav
  end
  
  # ファボってる？
  def favoriting?(target_micropost)
    self.favoritings.include?(target_micropost)
  end
end
