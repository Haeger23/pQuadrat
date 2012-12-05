# encoding: UTF-8

class Project < Model

  validates_presence_of   :title, :about
  validates_uniqueness_of :url, :case_sensitive => false
  validates_format_of     :title, :with => /^[a-zäöüß][\w+-]+[ ]?([\w+-]+[ ]?)*$/i
  validates_length_of     :title, :minimum => 4, :maximum => 30

  has_many :project_skills
  has_many :skills, :through => :project_skills
  has_many :categories, :through => :skills
  has_many :requests
  has_many :request_skills, :through => :requests
  has_many :project_skills, :through => :request_skills, :as => :p_skills
  has_many :skills, :through => :project_skills, :as => :requested_skills

  def title=(value)
    if value
      # trim
      value = value.strip.gsub(/\s/, " ")
      write_attribute(:url, value.gsub(/\W/, "_"))
    end
    super(value)
  end
end