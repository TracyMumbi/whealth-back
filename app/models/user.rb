class User < ApplicationRecord
    has_secure_password
    has_many :otps, dependent: :destroy
    has_many :growths
    has_many :projects, dependent: :destroy
    validates :email, uniqueness: true
    attribute :subscription_status, :boolean, default: false
    
    validates :phone, presence: true
    def generate_jwt
        payload = { user_id: id, role: 'User' }
        JsonWebToken.encode(payload)
    end
end
