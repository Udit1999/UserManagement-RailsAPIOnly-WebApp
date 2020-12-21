# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!, except: [:create]

      def show
        if params[:id].present?
          if (current_user.id == params[:id].to_i) || current_user.admin?
            @user = User.find(params[:id])
            render json: @user.to_json(except: :authentication_token)
          else
            head 403
          end
        else
          render json: current_user
        end
      end

      def show_all
        if current_user.admin?
          @users = User.all
          render json: @users.to_json(except: :authentication_token)
        else
          head 403
        end
      end

      def create
        if params[:password] == params[:password_confirmation]
          @user = User.create(create_user_params)
          if @user.save
            @session = Session.create(user_id: @user.id, token: generate_token)
            @session.save
            render json: @user
          else
            head :unprocessable_entity
          end

        else
          render json: { errors: 'password and password confirmation do not match' }, status: :unprocessable_entity
        end
      end

      def update
        user_params = if current_user.admin?
                        update_user_params
                      else
                        create_user_params
                      end
        if current_user.update(user_params)
          render json: current_user
        else
          render json: { errors: current_user.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        if params[:id].present?
          @user = User.find(params[:id])
          if current_user.admin? || (@user.id == current_user.id)
            @user.sessions.each(&:destroy)
            @user.destroy
            head :ok
          else
            head 403
          end
        else
          @user = User.find(current_user.id)
          @user.destroy
        end
      end

      private

      def create_user_params
        params.require(:user).permit(:name, :email, :password, :bio, :password_confirmation)
      end

      def update_user_params
        params.require(:user).permit(:name, :email, :password, :bio, :kind, :password_confirmation)
      end
    end
  end
end
