# encoding: UTF-8

class UserSkill < Model

  belongs_to :skill
  belongs_to :user

  has_one :category, :through => :skill

  validates_presence_of :skill, :user, :weight
  validates_numericality_of :weight, :only_integer => true
  validates_uniqueness_of :user_id, :scope => :skill_id, :message => "The user has already this skill"

end