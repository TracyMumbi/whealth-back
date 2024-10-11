class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :transaction_code, :amount
  has_one :user
end
