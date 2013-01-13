# encoding: UTF-8

class Project < Model
  include Paperclip::Glue

  has_many :user_projects, :dependent => :delete_all
  has_many :users, :through => :user_projects
  has_many :project_skills, :dependent => :delete_all
  has_many :skills, :through => :project_skills, :order => 'project_skills.weight DESC, skills.name ASC', :select => "*, project_skills.weight as weight"
  has_many :categories, :through => :skills
  has_many :requests
  has_many :request_skills, :through => :requests
  has_attached_file :image,
                    :default_url => '/images/projects/default/:style.png',
                    :default_style => :big,
                    :styles => {
                        :big => ["270x", :png],
                        :medium => ["128x128^", :png],
                        :small => ["64x64^", :png]
                    },
                    :convert_options => {
                        :medium => "-gravity center -extent 128x128",
                        :small => "-gravity center -extent 64x64"
                    },
                    :url => "/images/projects/:id/:style.png",
                    :path => PSquared.path+"/public:url"

  validates_presence_of   :title
  validates_uniqueness_of :url, :case_sensitive => false
  validates_format_of     :title, :with => /^[a-zäöüß][\w+-]+[ ]?([\w+-]+[ ]?)*$/i
  validates_length_of     :title, :minimum => 2, :maximum => 30
  validates_numericality_of :progress, :only_integer => true, :unless => lambda { |project| project.progress.nil? }
  validates_associated    :project_skills

  def image_file_name=(value)
    super(value.nil? ? nil : Time.now)
  end

  def title=(value)
    if value
      # trim
      value = value.strip.gsub(/\s/, " ")
      write_attribute(:url, value.gsub(/\W/, "_").downcase)
    end
    super(value)
  end
end