class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone, :password_digest, :gender, :username, :date_of_birth
  has_many :projects
end
