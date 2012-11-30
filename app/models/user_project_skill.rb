# encoding: UTF-8

class UserProjectSkill < Model

  belongs_to :user
  belongs_to :project_skill

  delegate :skill, :to => :project_skill

  validates_presence_of :user, :project_skill, :weight
  validates_numericality_of :weight

end