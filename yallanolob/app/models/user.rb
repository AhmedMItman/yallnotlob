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
  has_many :friends, class_name: "User",foreign_key: "friend_id"
  belongs_to :friend, class_name: "User"
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
