class Group < ApplicationRecord
  #The has_and_belongs_to_many Association
  has_and_belongs_to_many :Users

end
