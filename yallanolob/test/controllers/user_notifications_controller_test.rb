require 'test_helper'

class UserNotificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_notification = user_notifications(:one)
  end

  test "should get index" do
    get user_notifications_url
    assert_response :success
  end

  test "should get new" do
    get new_user_notification_url
    assert_response :success
  end

  test "should create user_notification" do
    assert_difference('UserNotification.count') do
      post user_notifications_url, params: { user_notification: { seen: @user_notification.seen } }
    end

    assert_redirected_to user_notification_url(UserNotification.last)
  end

  test "should show user_notification" do
    get user_notification_url(@user_notification)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_notification_url(@user_notification)
    assert_response :success
  end

  test "should update user_notification" do
    patch user_notification_url(@user_notification), params: { user_notification: { seen: @user_notification.seen } }
    assert_redirected_to user_notification_url(@user_notification)
  end

  test "should destroy user_notification" do
    assert_difference('UserNotification.count', -1) do
      delete user_notification_url(@user_notification)
    end

    assert_redirected_to user_notifications_url
  end
end
