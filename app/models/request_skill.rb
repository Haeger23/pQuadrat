# encoding: UTF-8

class RequestSkill < Model

  belongs_to :request
  belongs_to :project_skill

  validates_presence_of :request, :project_skill, :weight
  validates_numericality_of :weight, :only_integer => true
  validates_uniqueness_of :request_id, :scope => :project_skill_id, :message => "The request has already this skill"

end