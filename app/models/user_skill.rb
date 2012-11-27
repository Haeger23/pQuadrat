# encoding: UTF-8

class UserSkill < Model
  belongs_to :skill
  belongs_to :user
end