# encoding: UTF-8

class Category < Model

  has_many :skills

  validates_uniqueness_of :name, :case_sensitive => false
  validates_presence_of :name
  validates_length_of :name, :minimum => 4


end