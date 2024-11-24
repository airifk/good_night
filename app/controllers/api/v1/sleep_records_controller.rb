module Api
  module V1
    class SleepRecordsController < ApplicationController
      def create
        # POST /api/v1/sleep_records
        # sleep_record = current_user.sleep_records.new(sleep_record_params)
        
        # if sleep_record.save
        #   render json: { message: 'Sleep record created successfully', sleep_record: sleep_record }, status: :created
        # else
        #   render json: { errors: sleep_record.errors.full_messages }, status: :unprocessable_entity
        # end
        SaveSleepRecordJob.perform_later(
          current_user.id,
          sleep_record_params[:clock_in_time],
          sleep_record_params[:clock_out_time]
        )

        render json: { message: 'Sleep record is being processed in the background' }, status: :accepted
      end

      # GET /api/v1/sleep_records
      def index
        sleep_records = current_user.sleep_records.order(created_at: :desc)
        render json: { sleep_records: sleep_records }, status: :ok
      end

      private

      def sleep_record_params
        params.require(:sleep_record).permit(:clock_in_time, :clock_out_time)
      end
    end
  end
end
