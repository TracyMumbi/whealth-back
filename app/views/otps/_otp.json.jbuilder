json.extract! otp, :id, :otp_no, :user_id, :created_at, :updated_at
json.url otp_url(otp, format: :json)
