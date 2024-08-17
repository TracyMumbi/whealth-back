class ConsultantChannel < ApplicationCable::Channel
  private

  def channel_name_prefix
    'consultant_channel'
  end

  def expected_user_role
    'Consultant'
  end
end
