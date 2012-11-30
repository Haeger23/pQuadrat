# encoding: UTF-8

class Skill < Model

  belongs_to :category

  has_many :user_skills
  has_many :project_skills
  has_many :projects, :through => :project_skills

  validates_uniqueness_of :name, :case_sensitive => false
  validates_presence_of :name, :category
  validates_length_of :name, :minimum => 2

end