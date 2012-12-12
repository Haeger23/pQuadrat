# encoding: UTF-8

class Request < Model
  belongs_to :user
  belongs_to :project

  has_many :request_skills
  has_many :project_skills, :through => :request_skills
  has_many :skills, :through => :project_skills

  validates_associated    :user, :project
  validates_presence_of   :user, :project, :message
  validates_uniqueness_of :user_id, :scope => :project_id, :message => "The user has already a request for this project"
end