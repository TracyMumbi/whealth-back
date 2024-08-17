module ApplicationCable
    
    class UserChannel < ApplicationCable::Channel
        def subscribed
            stream_for "#{channel_name_prefix}_#{params["id"]}"
        end

        def unsubscribed
            # Any cleanup needed when channel is unsubscribed
        end

        private

        def channel_name_prefix
            raise NotImplementedError, 'Implement this method in the specific user channel.'
        end

        
        def expected_user_role
            raise NotImplementedError, 'Implement this method in the specific user channel.'
        end

    end
end
  