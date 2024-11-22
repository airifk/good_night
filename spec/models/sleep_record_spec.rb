require 'rails_helper'

RSpec.describe SleepRecord, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    let(:user) { FactoryBot.create(:user) }

    it 'requires a user' do
      sleep_record = FactoryBot.build(:sleep_record, user: nil)
      expect(sleep_record).not_to be_valid
    end

    it 'validates start time is before end time' do
      sleep_record = FactoryBot.build(:sleep_record, 
        user: user, 
        clock_in_time: Time.current, 
        clock_out_time: Time.current - 1.hour
      )
      
      expect(sleep_record).not_to be_valid
    end
  end
end