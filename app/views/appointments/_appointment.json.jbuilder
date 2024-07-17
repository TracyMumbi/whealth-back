json.extract! appointment, :id, :date, :content, :created_at, :updated_at
json.url appointment_url(appointment, format: :json)
