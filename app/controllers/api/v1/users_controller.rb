class Api::V1::UsersController < ApplicationController

    def show
        if signed_in?
            render json: current_user
        else
            head :unauthorized
        end
    end

    def create
        if params[:password]==params[:password_confirmation]
            @user = User.create(user_params)
            if @user.save
                current_user = @user
                render json: @user
            else
                head :unprocessable_entity
            end

        else
            render json: { errors: "password and password confirmation do not match" }, status: :unprocessable_entity
        end

    end
    def update
        if signed_in?
            if current_user.update_attributes(user_params)
                render json: current_user
            else
                render json: { errors: current_user.errors }, status: :unprocessable_entity
            end
        else
            head :unauthorized
        end
     end

    private
    def user_params
        params.require(:user).permit(:name, :email, :password, :bio, :usertype, :password_confirmation)
    end

end
