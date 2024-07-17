class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone, :password, :gender, :username, :date_of_birth
end
