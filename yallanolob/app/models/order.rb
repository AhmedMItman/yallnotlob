class Order < ApplicationRecord
  belongs_to :user
  has_many :items
  has_many :friend_orders
  has_attached_file :menu, styles: { large: "600x600>", medium: "300x300>", thumb: "100x100#" }
  validates_attachment_content_type :menu, content_type: /\Aimage\/.*\z/

end
