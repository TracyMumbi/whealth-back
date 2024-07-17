class User < ApplicationRecord
    has_many :otps, dependent: :destroy
end
