# encoding: UTF-8

class Project < Model

  validates_presence_of   :title
  validates_uniqueness_of :title
  validates_length_of     :title, :minimum => 4, :maximum => 30

  has_many :project_skills
  has_many :skills, :through => :project_skills
  has_many :categories, :through => :skills
  has_many :requests
  has_many :request_skills, :through => :requests
  has_many :project_skills, :through => :request_skills, :as => :p_skills
  has_many :skills, :through => :project_skills, :as => :requested_skills
end