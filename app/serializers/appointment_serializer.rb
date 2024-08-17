class AppointmentSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :date, :project_id, :status
  # has_one :project
end
