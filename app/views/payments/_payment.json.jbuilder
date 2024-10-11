json.extract! payment, :id, :project_id, :amount, :user_id, :paid_at, :created_at, :updated_at
json.url payment_url(payment, format: :json)
