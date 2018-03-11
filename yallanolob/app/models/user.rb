class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #The has_and_belongs_to_many Association
  has_and_belongs_to_many :Groups
  #2.3 The has_many Association
  has_many :orders
  has_many :items
  has_many :notifications
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
         :recoverable, :rememberable, :trackable, :validatable

  # def self.search(search)
  #   where("email LIKE ?","%#{search}%")
  # end

end
