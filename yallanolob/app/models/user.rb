class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #The has_and_belongs_to_many Association
  has_and_belongs_to_many :Groups
  #2.3 The has_many Association
  has_many :orders
  has_many :items
  has_many :notifications
  has_attached_file :image, styles: { large: "600x600>", medium: "300x300>", thumb: "100x100#" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  #
  #http://danielchangnyc.github.io/blog/2013/11/06/self-referential-associations/
  #
  # has_many :friends, class_name: "User",foreign_key: "friend_id"
  # belongs_to :friend, class_name: "User"

  # has_and_belongs_to_many :friendships,class_name: "User",join_table:  :friendships,
  #                         foreign_key: :user_id,
  #                         association_foreign_key: :friend_user_id

  # has_and_belongs_to_many(:users ,:join_table=>"friendships",:foreign_key =>"user_id",:association_foreign_key => "friend_user_id")
  # has_and_belongs_to_many(:users,:join_table => "friendships",:foreign_key =>"user_id",:association_foreign_key => "friend_user_id" )
  # has_many(:friendship, :foreign_key => :user_id, :dependent => :destroy)
  # has_many(:reverse_friendship, :class_name => :friendship,
  #          :foreign_key => :friend_user_id, :dependent => :destroy)
  #
  # has_many :users, :through => :friendship, :source => :friend_user_id

  has_many :friendships
  has_many :friends, :through => :friendships

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:omniauthable, :omniauth_providers => [:facebook, :google_oauth2,
*(:developer if Rails.env.development?)]

def self.new_with_session(params, session)
  super.tap do |user|
    if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
      user.email = data["email"] if user.email.blank?
    end
  end
end
def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end
before_create { generate_token(:auth_token) }

def send_password_reset
  generate_token(:password_reset_token)
  self.password_reset_sent_at = Time.zone.now
  save!
  UserMailer.password_reset(self).deliver
end

def generate_token(column)
  begin
    self[column] = SecureRandom.urlsafe_base64
  end while User.exists?(column => self[column])
end
end
