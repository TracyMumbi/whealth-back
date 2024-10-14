class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone, :password_digest, :gender, :username, :date_of_birth, :subscription_status
  has_many :projects
  has_many :growths
end
