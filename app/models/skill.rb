# encoding: UTF-8

class Skill < Model

  belongs_to :category

  has_many :user_skills
  has_many :users, :through => :user_skills, :select => "*, user_skills.weight as weight, user_skills.updated_at as changed_at, CASE WHEN user_skills.updated_at = user_skills.created_at THEN 'added' ELSE 'updated' END as action", :order => "user_skills.updated_at DESC, user_skills.weight DESC", :limit => 50
  has_many :project_skills
  has_many :projects, :through => :project_skills, :select => "*, project_skills.weight as weight, project_skills.updated_at as changed_at, CASE WHEN project_skills.updated_at = project_skills.created_at THEN 'added' ELSE 'updated' END as action", :order => "project_skills.updated_at DESC, project_skills.weight DESC", :limit => 50

  validates_uniqueness_of :url, :scope => :category_id, :case_sensitive => false
  validates_format_of     :name, :with => /^[a-zäöüß][\w+#-]+[ ]?([\w+#-]+[ ]?)*$/i
  validates_presence_of   :name, :category
  validates_length_of     :name, :minimum => 1, :maximum => 30

  def name=(value)
    if value
      # trim
      value = value.strip.gsub(/\s/, " ")
      write_attribute(:url, value.gsub(/\W/, "_").downcase)
    end
    super(value)
  end

  def users_count
    UserSkill.where(:skill_id => self.id).count
  end

  def projects_count
    ProjectSkill.where(:skill_id => self.id).count
  end

  def similar
    len = self.name.length
    if len < 5
      score = 2
    elsif len < 8
      score = 3
    elsif len < 10
      score = 4
    else
      score = 5
    end

    self.class.all(
        select: "*, levenshtein('#{self.name}', name) as similarity",
        conditions: ["id != ?", self.id],
        having: "similarity <= #{score}",
        order: "similarity ASC, name ASC",
        limit: 50
    )
  end

end