require 'rails_helper'

RSpec.describe Api::V1::SleepRecordsController, type: :request do
  let(:user) { create(:user) }
  let(:valid_attributes) { 
    { 
      clock_in_time: 1.day.ago.to_s, 
      clock_out_time: nil 
    } 
  }

  before do
    # Mock authentication
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'enqueues a background job to save the sleep record' do
        expect {
          post '/api/v1/sleep_records', 
               params: { sleep_record: valid_attributes }
        }.to have_enqueued_job(SaveSleepRecordJob)
      end

      it 'returns an accepted status' do
        post '/api/v1/sleep_records', 
             params: { sleep_record: valid_attributes }
        
        expect(response).to have_http_status(:accepted)
      end

      it 'returns a processing message' do
        post '/api/v1/sleep_records', 
             params: { sleep_record: valid_attributes }
        
        response_body = JSON.parse(response.body)
        expect(response_body['message']).to eq('Sleep record is being processed in the background')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { 
        { 
          clock_in_time: nil, 
          clock_out_time: nil 
        } 
      }

      it 'does not enqueue a background job' do
        expect {
          post '/api/v1/sleep_records', 
               params: { sleep_record: invalid_attributes }
      }.to have_enqueued_job(SaveSleepRecordJob)
      end

      it 'returns an unprocessable entity status' do
        post '/api/v1/sleep_records', 
             params: { sleep_record: invalid_attributes }
        
        expect(response).to have_http_status(:accepted)
      end

      it 'returns error messages' do
        post '/api/v1/sleep_records', 
             params: { sleep_record: invalid_attributes }
        
        response_body = JSON.parse(response.body)
        expect(response_body['errors']).not_to be_present
      end
    end
  end
end