# encoding: UTF-8

class UserProjectSkill < Model
  belongs_to :user
  belongs_to :project_skill

  delegate :skill, :to => :project_skill
end