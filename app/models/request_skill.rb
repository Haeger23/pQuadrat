# encoding: UTF-8

class RequestSkill < Model

  belongs_to :request
  belongs_to :project_skill

  validates_presence_of :request, :project_skill, :weight
  validates_numericality_of :weight

end