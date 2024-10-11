json.extract! transaction, :id, :transaction_code, :project_id, :amount, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
