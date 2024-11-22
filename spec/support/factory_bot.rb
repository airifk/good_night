RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    # Add any other required attributes for user creation
  end
end

# spec/factories/follows.rb
FactoryBot.define do
  factory :follow do
    association :follower, factory: :user
    association :followed, factory: :user
  end
end

# spec/factories/sleep_records.rb
FactoryBot.define do
  factory :sleep_record do
    association :user
    clock_in_time { Time.current }
    clock_out_time { clock_in_time + 8.hours }
  end
end