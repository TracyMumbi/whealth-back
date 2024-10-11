class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :amount, :paid_at
  has_one :project
  has_one :user
end
