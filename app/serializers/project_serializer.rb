class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :status, :body
  has_one :user
  has_one :consultant
  has_many :appointments
end
