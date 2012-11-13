class Category < ActiveRecord::Base
  attr_accessor :name

  has_many :skills
end