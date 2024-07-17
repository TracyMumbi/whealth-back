require_relative './JWT/json_web_token.rb'

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  # before_action :authorize_request

  def find_user_by_email
    user = find_user_in_models(params[:email], [User, Consultant, Admin])
    user || not_found
  end

  def not_found
    render plain: '404 Not Found', status: :not_found
  end

  private

  def authorize_request
    header = request.headers['Authorization']
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
    user = find_user_in_models(decoded[:user_id], [User, Consultant, Admin])
    user || not_found
  end

  def find_user_in_models(email_or_id, models)
    models.each do |model|
      user = model.find_by(email: email_or_id) || model.find_by(id: email_or_id)
      return user if user
    end
    nil
  end
end
