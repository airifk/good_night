class SaveSleepRecordJob < ApplicationJob
  queue_as :default

  def perform(user_id, clock_in_time, clock_out_time)
    user = User.find(user_id)

    sleep_record = user.sleep_records.new(
      clock_in_time: clock_in_time,
      clock_out_time: clock_out_time
    )

    if sleep_record.save
      Rails.logger.info "SleepRecord created successfully for User ##{user.id}"
    else
      Rails.logger.error "Failed to save SleepRecord: #{sleep_record.errors.full_messages.join(', ')}"
    end
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "User not found: #{e.message}"
  end
end