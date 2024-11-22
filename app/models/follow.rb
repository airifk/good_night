class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  validates :follower, :followed, presence: true
  validate :cannot_follow_self
  validates_uniqueness_of :follower, scope: :followed

  private

  def cannot_follow_self
    errors.add(:base, "Cannot follow yourself") if follower == followed
  end
end
