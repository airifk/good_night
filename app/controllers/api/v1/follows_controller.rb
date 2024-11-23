module Api
  module V1
    class FollowsController < ApplicationController
      # POST /api/v1/follows
      def create
        followed_user = User.find_by(id: params[:followed_id])

        if followed_user && current_user.following << followed_user
          render json: { message: "You are now following #{followed_user.name}" }, status: :created
        else
          render json: { errors: 'Unable to follow user' }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/follows/:id
      def destroy
        followed_user = current_user.following.find_by(id: params[:id])

        if followed_user
          current_user.following.destroy(followed_user)
          render json: { message: "You have unfollowed #{followed_user.name}" }, status: :ok
        else
          render json: { errors: 'Follow relationship not found' }, status: :not_found
        end
      end
    end
  end
end