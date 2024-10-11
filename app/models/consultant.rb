class Consultant < ApplicationRecord
    has_secure_password
    has_many :projects, dependent: :destroy
    validates :email, uniqueness: true
    validates :name, uniqueness: true
    validates :username, uniqueness: true
    validates :board_number, uniqueness: true
    
    validates :phone, presence: true
    def generate_jwt
        payload = { user_id: id, role: 'Consultant' }
        JsonWebToken.encode(payload)
    end
end
