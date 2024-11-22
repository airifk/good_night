require 'rails_helper'

RSpec.describe Follow, type: :model do
  describe 'associations' do
    it { should belong_to(:follower).class_name('User') }
    it { should belong_to(:followed).class_name('User') }
  end

  describe 'validations' do
    let(:user1) { FactoryBot.create(:user) }
    let(:user2) { FactoryBot.create(:user) }

    it 'requires a follower' do
      follow = FactoryBot.build(:follow, follower: nil, followed: user2)
      expect(follow).not_to be_valid
    end

    it 'requires a followed user' do
      follow = FactoryBot.build(:follow, follower: user1, followed: nil)
      expect(follow).not_to be_valid
    end

    it 'prevents self-following' do
      follow = FactoryBot.build(:follow, follower: user1, followed: user1)
      expect(follow).not_to be_valid
    end
  end
end