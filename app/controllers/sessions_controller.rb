class SessionsController < ApplicationController
  before_action :authorize_request, except: [:create]

  def create
    @role = request.headers['Role']
    @user = find_user_by_email

    if @user && @user.authenticate(params[:password])
      serialized_user = serialize_user(@user)
      render json: { 
        user: serialized_user,
        token: @user.generate_jwt,
      }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def serialize_user(user)
    if user.is_consultant
      ConsultantSerializer.new(user)
    else
      UserSerializer.new(user)
    end
  end

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
  
end
