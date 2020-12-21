# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      def create
        user = User.find_by(email: params[:email])
        if user&.valid_password?(params[:password])
          @current_user = user
          token = generate_token
          s = Session.create(user_id: @current_user.id, token: token)
          s.save
          response.set_header('token', s.token)
        #   render json: { messages: {'Successfully Logged In'} }, status: :ok
        else
          render json: { errors: { 'email or password' => ['is invalid'] } }, status: :unprocessable_entity
        end
      end

      def destroy
        @session = Session.find_by(token: @current_user_token)
        @session.destroy
      end
    end
  end
end
