class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  skip_before_action :authorize_request, only: %i[ create ]

  # GET /users or /users.json
  def index
    sort_column = params[:sort_column] || 'email' # Default to 'email' if not provided
    sort_direction = params[:sort_direction] || 'asc' # Default to 'asc' if not provided
    start_date = params[:start_date] || Date.new(1900, 1, 1)
    end_date = params[:end_date] || Date.current
    search_query = params[:search]

    # Validate the sort direction to prevent SQL injection
    sort_direction = %w[asc desc].include?(sort_direction) ? sort_direction : 'asc'

    @users = User
              .where(created_at: start_date.beginning_of_day..end_date.end_of_day)
              .where("name LIKE ?", "%#{search_query}%")
              .order("#{sort_column} #{sort_direction}")
              .paginate(page: params[:page] || 1, per_page: params[:limit] || 10)

    render json: {
      total_pages: @users.total_pages,
      previous_page: @users.previous_page,
      next_page: @users.next_page,
      docs: ActiveModelSerializers::SerializableResource.new(
        @users,
        each_serializer: UserSerializer
      )
    }, scope: {
      params: params
    }
  end

  # GET /users/1 or /users/1.json
  def show
    render json: @user, scope: { params: params }
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    @user.password = params[:password]


    if @user.save
      render json: { 
        user: UserSerializer.new(@user, scope: { params: params }) 
      }, scope: { params: params }, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end


  # PATCH/PUT /users/1 or /users/1.json
  def update
    if params[:password].present?
      @user.password = params[:password]
      generate_and_send_otp(@user)
    end

    if @user.update(user_params)
      render json: @user, scope: { params: params }
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # POST /users/forgot_password
  def forgot_password
    @user = User.find_by(email: params[:email])
    if @user
      generate_and_send_otp(@user)
      render json: { message: 'OTP sent to your email.' }, status: :ok
    else
      render json: { error: 'Email not found in our database' }, status: :not_found
    end
  end

  # POST /users/reset_password
  def reset_password
    @user = User.find_by(email: params[:email])
    if @user
      if params[:password].present?
        @user.password = params[:password]

        if @user.save
          render json: { message: 'Password reset successfully. OTP sent.' }, status: :ok
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      else
        render json: { error: 'Password is required.' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Email not found in our database' }, status: :not_found
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    if @user.update(is_deleted: !@user.is_deleted)
      render json: @user, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :phone, :password, :subscription_status, :gender, :date_of_birth, :username, :is_client, :is_consultant)
  end

  def generate_and_send_otp(user)
    otp = SecureRandom.random_number(10_000).to_s.rjust(4, '0')
    Otp.create(otp_no: otp, user_id: user.id)
    MyMailer.index(user, otp).deliver_now
  end
end
