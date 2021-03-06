# encoding: UTF-8

class User < Model
  include Paperclip::Glue

  before_validation :strip

  validates_presence_of   :username, :password, :mail
  validates_uniqueness_of :url, :case_sensitive => false
  validates_format_of     :username, :with => /^[a-zäöüß][\w+-]+[ ]?([\w+-]+[ ]?)*$/i
  validates_length_of     :username, :minimum => 2, :maximum => 30
  validates_length_of     :forename, :surname, :maximum => 30
  validates_length_of     :password, :minimum => 6, :maximum => 30, :if => :password_changed?
  validates_format_of     :mail, :with => /\A([\w\.\-\+]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_each :forename, :surname do |record, attr, value|
    record.errors.add(attr, 'must start with upper case') if value =~ /\A[a-z]/
  end

  before_save :changePassword

  has_many :user_projects, :dependent => :delete_all
  has_many :projects, :through => :user_projects, :select => "*, projects.id as id, user_projects.is_admin as is_admin"
  has_many :user_skills, :dependent => :delete_all
  has_many :skills, :through => :user_skills, :order => 'user_skills.weight DESC, skills.name ASC', :select => "*, user_skills.weight as weight"
  has_many :categories, :through => :skills
  has_many :requests
  has_attached_file :image,
                    :default_url => '/images/users/default/:style.png',
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
                    :url => "/images/users/:id/:style.png",
                    :path => PSquared.path+"/public:url"

  def image_file_name=(value)
    super(value.nil? ? nil : Time.now)
  end

  def self.login(username, password)
    user = self.find_by_username(username)
    return nil unless user

    if user.encrypt(password) == user.password
      user
    end
  end

  def encrypt(password)
    require "digest/sha1"
    Digest::SHA1.hexdigest(password + self.salt)
  end

  def username=(value)
    if value
      # trim
      value = value.strip.gsub(/\s/, " ")
      write_attribute(:url, value.gsub(/\W/, "_").downcase)
    end
    super(value)
  end

protected
  def strip
    #strip
    [:username, :password, :mail, :forename, :surname].each do |attr|
      self[attr].strip! if self[attr].respond_to?(:strip!)
    end
  end

  def create_salt
    chars = ("a".."z").to_a
    value = 16.times.to_a.collect { chars[rand(26)] }.join("")
    self.salt = value
  end

  def changePassword
    if password_changed?
      create_salt if self.salt.nil?
      self.password = encrypt(self.password)
    end
  end
end