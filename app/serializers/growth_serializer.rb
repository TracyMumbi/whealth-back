class GrowthSerializer < ActiveModel::Serializer
  attributes :id, :weight, :height, :age, :length, :head_circumference
end
