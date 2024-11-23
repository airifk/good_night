require 'rails_helper'

RSpec.describe SleepRecord, type: :model do
  describe 'validations' do
    let(:user) { FactoryBot.create(:user) }

    it 'validates start time is before end time' do
      sleep_record = FactoryBot.build(:sleep_record, 
        user: user, 
        clock_in_time: Time.current, 
        clock_out_time: nil
      )

      sleep_record = FactoryBot.build(:sleep_record, 
        user: user, 
        clock_in_time: nil, 
        clock_out_time: Time.current - 1.hour
      )
      
      expect(sleep_record).not_to be_valid
    end
  end
end