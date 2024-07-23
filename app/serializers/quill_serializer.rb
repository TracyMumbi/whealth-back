class QuillSerializer < ActiveModel::Serializer
  attributes :id, :content
  has_one :project
end
