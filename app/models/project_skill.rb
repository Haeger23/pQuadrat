# encoding: UTF-8

class ProjectSkill < Model
  belongs_to :project
  belongs_to :skill

  has_many :request_skills
  has_many :requests, :through => :request_skills

  validates_presence_of :project, :skill, :weight
  validates_numericality_of :weight, :only_integer => true
  validates_uniqueness_of :project_id, :scope => :skill_id, :message => "The project has already this skill"

end