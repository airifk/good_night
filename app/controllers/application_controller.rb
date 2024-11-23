class ApplicationController < ActionController::API
  before_action :current_user
  
  def current_user
    @current_user ||= User.find_by(id: params[:user_id])
    render json: { error: 'User not found' }, status: :not_found unless @current_user

    @current_user
  end
end
