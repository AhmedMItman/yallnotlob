class NotifyChannel < ApplicationCable::Channel
  def subscribed
     stream_from "notify_channel_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def invite
  end
end
