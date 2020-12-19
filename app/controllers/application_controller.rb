class ApplicationController < ActionController::API
    # protect_from_forgery with: :null_session

    respond_to :json

    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :authenticate_user

    private

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :bio, :usertype])
    end

    def authenticate_user
        if request.headers['token'].present?
          session = Session.find_by(token: request.headers['token'])
          if session.nil?
            head :unauthorized 
          else
            @current_user = User.find(session.user_id)    
            if @current_user
              @current_user_id = @current_user.id
            else
              head :unauthorized
            end
          end
        end
    end
    def authenticate_user!(options = {})
        head :unauthorized unless signed_in?
    end
    
    def current_user
        @current_user ||= super || User.find(@current_user_id)
    end
    
    def signed_in?
      authenticate_user
      @current_user_id.present?
    end
        
end
