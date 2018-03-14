class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, :class_name => "User"

  def name_for_friends
    "#{User.find(friend_id).name}"
  end

  def image_for_friends
    "#{User.find(friend_id).image}"
  end

end
