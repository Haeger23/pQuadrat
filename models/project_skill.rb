class ProjectSkill < ActiveRecord::Base
  attr_accessor :weight
  belongs_to :project
  belongs_to :skills

  has_many :request_skills
  has_many :requests, :through => :request_skills
end