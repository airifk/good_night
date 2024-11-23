Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Routes for SleepRecords
      resources :sleep_records, only: [:create, :index]

      # Routes for Follows (follow and unfollow)
      resources :follows, only: [:create, :destroy]

      # Route to get sleep records of followed users
      get 'friends_sleep_records', to: 'friends_sleep_records#index'
    end
  end
end