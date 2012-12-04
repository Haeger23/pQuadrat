# encoding: UTF-8

class Skill < Model

  belongs_to :category

  has_many :user_skills
  has_many :project_skills
  has_many :projects, :through => :project_skills

  validates_uniqueness_of :url, :scope => :category_id, :case_sensitive => false
  validates_format_of     :name, :with => /^[a-z0-9_-äöü\+ ]+$/i
  validates_presence_of :name, :category
  validates_length_of :name, :minimum => 2

  def name=(value)
    super
    write_attribute(:url, value.downcase.gsub(/\W/, "_"))
  end

end