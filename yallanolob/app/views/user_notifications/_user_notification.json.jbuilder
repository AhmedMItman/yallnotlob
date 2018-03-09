json.extract! user_notification, :id, :seen, :created_at, :updated_at
json.url user_notification_url(user_notification, format: :json)
