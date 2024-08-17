require_relative './JWT/json_web_token.rb'

class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token
    before_action :authorize_request


    def find_user_by_email
      @role = request.headers['Role']
      case @role
        when 'Consultant'
          Consultant.find_by(email: params[:email])
        # when 'Admin'
        #   Admin.find_by(email: params[:email])
        else
          User.find_by(email: params[:email])
      end
    end
    
    def not_found
      render plain: '404 Not Found', status: :not_found
    end
    
    private
    
    def authorize_request
      header = request.headers['Authorization']
      @role = request.headers['Role']
      token = header.split(' ').last if header
      
      begin
        decoded = JsonWebToken.decode(token)
        @current_user = get_user(decoded)
      rescue JWT::DecodeError
        render json: { error: 'Token has expired. Please log in again.' }, status: :unauthorized
        
      rescue JWT::DecodeError
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    end

    def get_user(decoded)
      @user_role = decoded[:role]
      case decoded[:role]
        when 'Consultant'
          Consultant.find(decoded[:user_id])
        when 'Admin'
          Admin.find(decoded[:user_id])
        else
          User.find(decoded[:user_id])
      end
    end
    
end