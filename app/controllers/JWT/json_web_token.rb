require 'jwt'

module JsonWebToken
  # Set the secret key to a random string. This should be kept secret in production.
  # SECRET_KEY = Rails.application.secrets.secret_key_base.to_s
  SECRET_KEY = Rails.application.credentials.secret_key_base.to_s

  # Add an expiration claim for 2 weeks (in seconds)
  EXPIRATION_TIME = 2.weeks.to_i

  def self.encode(payload)
    # Add the 'exp' claim to the payload with the expiration time
    payload[:exp] = Time.now.to_i + EXPIRATION_TIME

    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  end
end