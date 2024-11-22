require 'rails_helper'

RSpec.describe User, type: :model do
  # Association tests
  describe 'associations' do
    it { should have_many(:sleep_records) }
    it { should have_many(:follows_as_follower).class_name('Follow').with_foreign_key('follower_id') }
    it { should have_many(:follows_as_followed).class_name('Follow').with_foreign_key('followed_id') }
    it { should have_many(:following).through(:follows_as_follower).source(:followed) }
    it { should have_many(:followers).through(:follows_as_followed).source(:follower) }
  end

  # Relationship functionality tests
  describe 'user relationships' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    it 'can follow another user' do
      follow = create(:follow, follower: user1, followed: user2)
      
      expect(user1.following).to include(user2)
      expect(user2.followers).to include(user1)
    end

    it 'can have multiple followers and followings' do
      user3 = create(:user)
      
      create(:follow, follower: user1, followed: user2)
      create(:follow, follower: user3, followed: user1)
      
      expect(user1.following).to include(user2)
      expect(user1.followers).to include(user3)
    end

    it 'prevents duplicate follows' do
      create(:follow, follower: user1, followed: user2)
      duplicate_follow = build(:follow, follower: user1, followed: user2)
      
      expect(duplicate_follow).not_to be_valid
    end
  end

  # Sleep record association tests
  describe 'sleep records' do
    let(:user) { create(:user) }

    it 'can have multiple sleep records' do
      create_list(:sleep_record, 3, user: user)
      
      expect(user.sleep_records.count).to eq(3)
    end
  end
end