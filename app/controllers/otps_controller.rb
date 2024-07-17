class OtpsController < ApplicationController
  # before_action :authorize_request, except: [:confirm_otp]
  before_action :authorize_request, except: [:confirm_otp, :index]


  # GET /otps or /otps.json
  def index
    @otps = Otp.all
    render json: @otps
  end

  # GET /otps/1 or /otps/1.json
  def show
    @otp = Otp.find(params[:id])
    render json: @otp
  end

  # GET /otps/new
  def new
    @otp = Otp.new
  end

  # GET /otps/1/edit
  def edit
  end

  # PATCH/PUT /otps/1 or /otps/1.json
  def update
    @otp = Otp.find(params[:id])
    if @otp.update(otp_params)
      render json: @otp
    else
      render json: @otp.errors, status: :unprocessable_entity
    end
  end

  def confirm_otp
    user = User.find_by(email: params[:email])
    if user
      Rails.logger.info("User found: #{user.email}")
      Rails.logger.info("Params OTP: #{params[:otp][:otp_no]}")
      @matching_otp = user.otps.find_by(otp_no: params[:otp][:otp_no].to_s)
      if @matching_otp
        Rails.logger.info("OTP matched: #{params[:otp][:otp_no]}")
        user.otps.destroy_all
  
        render json: { 
          message: 'OTP matched! Confirmation sent.',  
          matching_otp: @matching_otp 
        }
      else
        Rails.logger.info("OTP did not match: #{params[:otp][:otp_no]}")
        render json: { message: 'OTP did not match!' }, status: :unauthorized
      end
    else
      Rails.logger.info("User not found: #{params[:email]}")
      render json: { message: "User with that email, #{params[:email]}, not found" }, status: :unauthorized
    end
  end
  
  

  private

    # Only allow a list of trusted parameters through.
    def otp_params
      params.require(:otp).permit(:otp_no, :user_id)
    end
end
