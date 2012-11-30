# encoding: UTF-8

class UserSkill < Model
  belongs_to :skill
  belongs_to :user

  has_one :category, :through => :skill
end