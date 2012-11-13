class Request < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  has_many :request_skills
  has_many :project_skills, :through => :request_skills
  has_many :skills, :through => :project_skills
end