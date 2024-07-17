class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :status
  has_one :user
end
