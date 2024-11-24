class FollowSleepRecordSerializer < ActiveModel::Serializer
  attributes :user_id, :name, :duration

  def user_id
    object.user.id
  end

  def name
    object.user_name
  end

  def duration
    object.duration
  end
end