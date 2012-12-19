# encoding: UTF-8

class Skill < Model

  belongs_to :category

  has_many :user_skills
  has_many :project_skills
  has_many :projects, :through => :project_skills

  validates_uniqueness_of :url, :scope => :category_id, :case_sensitive => false
  validates_format_of     :name, :with => /^[a-zäöüß][\w+-]+[ ]?([\w+-]+[ ]?)*$/i
  validates_presence_of   :name, :category
  validates_length_of     :name, :minimum => 2, :maximum => 30

  def name=(value)
    if value
      # trim
      value = value.strip.gsub(/\s/, " ")
      write_attribute(:url, value.gsub(/\W/, "_").downcase)
    end
    super(value)
  end

end