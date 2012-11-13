class Skill < ActiveRecord::Base

  belongs_to :category

  has_many :user_skills
  has_many :project_skills
  has_many :projects, :through => :project_skills

end