json.extract! notification, :id, :message, :from, :type, :orderId, :created_at, :updated_at
json.url notification_url(notification, format: :json)
