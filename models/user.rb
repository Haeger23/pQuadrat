# encoding: UTF-8

class User < ActiveRecord::Base
  before_validation :strip

  validates_presence_of   :username, :password, :mail
  validates_uniqueness_of :username
  validates_length_of     :username, :forename, :surname, :maximum => 50
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

  def strip
    #strip
    [:username, :password, :mail, :forename, :surname].each do |attr|
      self[attr].strip! if self[attr].respond_to?(:strip!)
    end
  end

  def changePassword
    if password_changed?
      require "digest/sha1"
      write_attribute("password", Digest::SHA1.hexdigest(self.password))
    end
  end
end