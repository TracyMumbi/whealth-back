class OtpNoSerializer < ActiveModel::Serializer
  attributes :id, :otp_no
  belongs_to :use
end
