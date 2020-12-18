class Api::V1::SessionsController < ApplicationController

    def create
        user = User.find_by_email(params[:email])    
        if user && user.valid_password?(params[:password])
          @current_user = user
          response.set_header('token', @current_user.authentication_token)
        #   render json: { messages: {'Successfully Logged In'} }, status: :ok 
        else
          render json: { errors: { 'email or password' => ['is invalid'] } }, status: :unprocessable_entity
        end
      end

    def destroy
        @current_user.authentication_token = nil
        @current_user.save
    end
    
end
