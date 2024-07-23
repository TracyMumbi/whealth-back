class AppointmentSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :date, :project_id
  # has_one :project
end
