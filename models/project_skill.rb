class ProjectSkill < ActiveRecord::Base
  belongs_to :project
  belongs_to :skill

  has_many :request_skills
  has_many :requests, :through => :request_skills
end