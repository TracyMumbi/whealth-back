class ConsultantSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone, :gender, :date_of_birth, :username, :email, :password_digest, :speciality, :board_number, :experience, :is_client, :is_consultant
  has_many :projects
end
