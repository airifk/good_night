class SleepRecord < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :clock_in_time, presence: true, if: -> { clock_out_time.blank? }
  validates :clock_out_time, presence: true, if: -> { clock_in_time.blank? }
  validate :clock_out_time_after_clock_in_time
  validate :must_clock_out_first
  validate :must_clock_in_first
  validate :check_for_double_time

  scope :clock_ins, -> { where.not(clock_in_time: nil) }
  scope :clock_outs, -> { where.not(clock_out_time: nil) }

  def duration
    return 0 if clock_out_time.blank?
    
    clock_out_time - clock_in_time
  end

  def must_clock_out_first
    return unless clock_out_time.blank? # This means that the user is trying to clock in

    if user.clock_ins.size != 0 && user.clock_ins.size == user.clock_outs.size + 1
      errors.add(:clock_in_time, "must clock out first")
      return false
    end
  end

  def must_clock_in_first
    return unless clock_in_time.blank? # This means that the user is trying to clock out

    if user.clock_ins.size == user.clock_outs.size
      errors.add(:clock_in_time, "must clock in first")
      return false
    end
  end

  private

  def clock_out_time_after_clock_in_time
    return if clock_out_time.blank? || clock_in_time.blank?

    if clock_out_time <= clock_in_time
      errors.add(:clock_out_time, "must be after start time")
      return false
    end
  end

 
  
  def check_for_double_time
    if clock_in_time.present? && clock_out_time.present?
      errors.add(:base, "Please select one time only")
      return false
    end
  end
end
