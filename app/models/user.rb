# encoding: UTF-8

class User < ActiveRecord::Base
  before_validation :strip

  validates_presence_of   :username, :password, :mail
  validates_uniqueness_of :username
  validates_length_of     :username, :minimum => 4, :maximum => 30
  validates_length_of     :forename, :surname, :maximum => 30
  validates_length_of     :password, :minimum => 6, :maximum => 30, :if => :password_changed?
  validates_format_of     :mail, :with => /\A([\w\.\-\+]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_each :forename, :surname do |record, attr, value|
    record.errors.add(attr, 'must start with upper case') if value =~ /\A[a-z]/
  end

  before_save :changePassword

  has_many :user_projects
  has_many :projects, :through => :user_projects
  has_many :user_skills
  has_many :skills, :through => :user_skills
  has_many :categories, :through => :skills
  has_many :requests

  def self.login(username, password)
    user = self.find_by_username(username)
    return nil unless user

    if user.encrypt(password) === user.password
      user
    end
  end

  def encrypt(password)
    require "digest/sha1"
    Digest::SHA1.hexdigest(password + self.salt)
  end

protected
  def strip
    #strip
    [:username, :password, :mail, :forename, :surname].each do |attr|
      self[attr].strip! if self[attr].respond_to?(:strip!)
    end
  end

  def create_salt
    value = ""
    chars = ("a".."z").to_a
    16.times.each { value << chars[rand(26)] }
    self.salt = value
  end

  def changePassword
    if password_changed?
      require "digest/sha1"
      create_salt if self.salt.nil?
      self.password = encrypt(self.password)
    end
  end
end