class UserChannel < ApplicationCable::Channel
  private

  def channel_name_prefix
    'user_channel'
  end

  def expected_user_role
    'User'
  end
end
