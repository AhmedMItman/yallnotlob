class UserNotification < ApplicationRecord
  # self.primary_keys = :user_id, :notification_id
  belongs_to :user
  belongs_to :notification
end
