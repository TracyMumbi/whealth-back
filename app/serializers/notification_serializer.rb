class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :message
  has_one :appointment
end
