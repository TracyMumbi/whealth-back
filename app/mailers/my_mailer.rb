# class MyMailer < ApplicationMailer
#     def index(user, otp)
#       @otp = otp.otp_no
#       @user = user
#       mail(to: @user.email, subject: "Welcome to Whealth") do |format|
#         format.html
#       end
#     end
#   end
  class MyMailer < ApplicationMailer
    def index(user, otp_value)
      @user = user
      @otp = otp_value
      mail(to: @user.email, subject: 'Your OTP Code')
    end
  end
  