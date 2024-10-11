require "base64"
require "excon"
require "json"

def access_token
    begin
      consumer_key = "w0YT1NYr83LDuZkItt5UxXwfGBGyndcvG9APKd0QW0qESkDT"#Rails.application.credentials.mpesa_consumer_key
      consumer_secret = "q5wsiM6zdZtq2M1SInzM6iSXEGU7xZwxMfnYYA75QDpGiz073m9mg3vzjpzKLqJF"#Rails.application.credentials.mpesa_consumer_secret
      
      enc=Base64.strict_encode64("#{consumer_key}:#{consumer_secret}")

      url="https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials"
      puts enc
      response=Excon.get(url,:headers=>{
        "Authorization": "Basic #{enc}"})

      puts response.status
      puts response.body
      data=JSON.parse(response.body)
      # p data
      # p response.body
      # p data["access_token"]
      return data["access_token"]
    rescue
      puts" error doing json parse"
      return nil
    end
end

# puts access_token
