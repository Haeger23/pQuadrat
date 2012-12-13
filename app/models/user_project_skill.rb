# encoding: UTF-8

class UserProjectSkill < Model

  belongs_to :user
  belongs_to :project_skill

  delegate :skill, :to => :project_skill

  validates_presence_of :user, :project_skill, :weight
  validates_numericality_of :weight, :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  validates_uniqueness_of :user_id, :scope => :project_skill_id, :message => "The user has already this skill of the project"

end