class UserProjectSkill < ActiveRecord::Base
  belongs_to :user
  belongs_to :project_skill

  delegate :skill, :to => :project_skill
end