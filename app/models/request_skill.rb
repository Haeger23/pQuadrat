# encoding: UTF-8

class RequestSkill < Model

  belongs_to :request
  belongs_to :project_skill

  validates_presence_of :request, :project_skill, :weight
  validates_numericality_of :weight, :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  validates_uniqueness_of :request_id, :scope => :project_skill_id, :message => "The request has already this skill"

end