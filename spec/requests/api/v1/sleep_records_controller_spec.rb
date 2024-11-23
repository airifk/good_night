require 'rails_helper'

RSpec.describe Api::V1::SleepRecordsController, type: :request do
  let(:user) { create(:user) }
  let(:valid_attributes) { 
    { 
      user_id: user.id,
      clock_in_time: 1.day.ago
    } 
  }
  let(:valid_attributes_2) { 
    { 
      user_id: user.id,
      clock_out_time: Date.today
    } 
  }

  before do
    # Simulate user authentication
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new sleep record' do
        expect {
          post '/api/v1/sleep_records', params: { sleep_record: valid_attributes }
        }.to change(user.sleep_records, :count).by(1)
      end

      it 'returns a created status' do
        post '/api/v1/sleep_records', params: { sleep_record: valid_attributes }
        expect(response).to have_http_status(:created)
      end

      it 'returns a success message' do
        post '/api/v1/sleep_records', params: { sleep_record: valid_attributes }
        response_body = JSON.parse(response.body)
        expect(response_body['message']).to eq('Sleep record created successfully')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { 
        { 
          clock_in_time: nil, 
          clock_out_time: nil 
        } 
      }

      it 'does not create a new sleep record' do
        expect {
          post '/api/v1/sleep_records', params: { sleep_record: invalid_attributes }
        }.not_to change(user.sleep_records, :count)
      end

      it 'returns an unprocessable entity status' do
        post '/api/v1/sleep_records', params: { sleep_record: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        post '/api/v1/sleep_records', params: { sleep_record: invalid_attributes }
        response_body = JSON.parse(response.body)
        expect(response_body['errors']).to be_present
      end
    end
  end

  describe 'GET #index' do
    before do
      # Create some sleep records for the user
      create_list(:sleep_record, 1, user: user)
    end

    it 'returns all user sleep records' do
      get '/api/v1/sleep_records'
      response_body = JSON.parse(response.body)
      expect(response_body['sleep_records'].size).to eq(1)
    end

    it 'returns records in descending order of creation' do
      get '/api/v1/sleep_records'
      response_body = JSON.parse(response.body)
      created_at_times = response_body['sleep_records'].map { |record| record['created_at'] }
      expect(created_at_times).to eq(created_at_times.sort.reverse)
    end

    it 'returns http success' do
      get '/api/v1/sleep_records'
      expect(response).to have_http_status(:ok)
    end
  end
end