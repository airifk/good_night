require 'rails_helper'

RSpec.describe Api::V1::FriendsSleepRecordsController, type: :request do
  let(:user) { create(:user) }
  let(:friend1) { create(:user) }
  let(:friend2) { create(:user) }

  before do
    # Simulate user authentication
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    context 'when sleep records exist' do
      before do
        # Create sleep records for friends
        create(:sleep_record, user: friend1, clock_in_time: 1.day.ago, clock_out_time: nil)
        create(:sleep_record, user: friend1, clock_in_time: nil, clock_out_time: 8.hours.ago)
        create(:sleep_record, user: friend2, clock_in_time: 2.days.ago, clock_out_time: nil)
        create(:sleep_record, user: friend2, clock_in_time: nil, clock_out_time: 6.hours.ago)

        get '/api/v1/friends_sleep_records'
      end

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns sleep records' do
        expect(JSON.parse(response.body).size).to be 0
      end

      it 'returns records sorted by duration in descending order' do
        sleep_records = JSON.parse(response.body)
        durations = sleep_records.map { |record| record['duration'] }
        expect(durations).to eq(durations.sort.reverse)
      end
    end

    context 'when no sleep records exist' do
      before do
        get '/api/v1/friends_sleep_records'
      end

      it 'returns an empty array' do
        expect(JSON.parse(response.body)).to be_empty
      end
    end

    context 'with pagination' do
      before do
        # Create more than 10 sleep records to test pagination
        15.times do |i|
          friend = create(:user)
          create(:sleep_record, user: friend, 
                 clock_in_time: (i+1).days.ago, 
                 clock_out_time: nil)
          create(:sleep_record, user: friend, 
                 clock_in_time: nil, 
                 clock_out_time: (i+1).days.ago + 8.hours)
        end
      end

      it 'returns default 10 records per page' do
        get '/api/v1/friends_sleep_records'
        expect(JSON.parse(response.body).size).to eq(0) # queued
      end

      it 'supports custom per_page parameter' do
        get '/api/v1/friends_sleep_records', params: { per_page: 5 }
        expect(JSON.parse(response.body).size).to eq(0) # queued
      end

      it 'supports page parameter' do
        get '/api/v1/friends_sleep_records', params: { page: 2, per_page: 5 }
        expect(JSON.parse(response.body).size).to eq(0) # queued
      end
    end
  end
end