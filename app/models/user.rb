class User < ApplicationRecord
  has_many :sleep_records
  has_many :follows_as_follower, class_name: 'Follow', foreign_key: 'follower_id'
  has_many :follows_as_followed, class_name: 'Follow', foreign_key: 'followed_id'
  has_many :following, through: :follows_as_follower, source: :followed
  has_many :followers, through: :follows_as_followed, source: :follower
end
