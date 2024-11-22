class SleepRecord < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :clock_in_time, :clock_out_time, presence: true
  validate :clock_out_time_after_clock_in_time

  def duration
    clock_out_time - clock_in_time
  end

  private

  def clock_out_time_after_clock_in_time
    return if clock_out_time.blank? || clock_in_time.blank?

    if clock_out_time <= clock_in_time
      errors.add(:clock_out_time, "must be after start time")
    end
  end
end
