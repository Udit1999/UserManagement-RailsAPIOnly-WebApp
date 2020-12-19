class Api::V1::UsersController < ApplicationController
    before_action :authenticate_user!, except: [:create]
    
    
    def show    
        if (params[:id].present?)
            if current_user.id==params[:id].to_i or current_user.admin?
                @user = User.find(params[:id])
                render json: @user.to_json(:except => :authentication_token)
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
            render json: @users.to_json(:except => :authentication_token)
        else
            head 403
        end
        
    end


    def create
        if params[:password]==params[:password_confirmation]
            @user = User.create(create_user_params)
            if @user.save
                current_user = @user
                @session = Session.create(:user_id => @user.id, :token => generate_token)
                @session.save
                render json: @user
            else
                head :unprocessable_entity
            end

        else
            render json: { errors: "password and password confirmation do not match" }, status: :unprocessable_entity
        end

    end
    def update
        if current_user.admin?
            user_params = update_user_params
        else
            user_params = create_user_params
        end
        if current_user.update_attributes(user_params)
            render json: current_user
        else
            render json: { errors: current_user.errors }, status: :unprocessable_entity
        end
     end


     def destroy
        if (params[:id].present?)
            @user = User.find(params[:id])
            if current_user.admin? or @user.id==current_user.id
                for session in @user.sessions
                    session.destroy
                end
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
