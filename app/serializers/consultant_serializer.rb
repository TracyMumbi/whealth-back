class ConsultantSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone, :gender, :date_of_birth, :email, :password, :speciality, :board_number, :experience, :is_client, :is_consultant
end
