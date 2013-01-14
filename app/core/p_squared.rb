# encoding: UTF-8

module PSquared
  class << self
    attr_accessor :user, :debug, :path
  end

  self.user = nil
  self.debug = false
  self.path = File.expand_path "../..", __FILE__

  gem 'activerecord'
  gem 'mysql2'
  gem 'sinatra'
  gem 'paperclip', :git => "git://github.com/thoughtbot/paperclip.git"
  gem 'pony'

  def self.initializeDatabase(file)
    require 'active_record'
    require 'mysql2'
    require 'yaml'  # YAML is a human friendly data serialization standard
    require 'paperclip' # paperclip is for file attachments
    require 'json'
    require 'builder' # for creating XML markup and data structures
    require 'active_support/time'

    # initialize database
    require PSquared.path+"/core/model"
    # load models
    Dir[PSquared.path+"/models/*"].each do |f|
      require f
    end
    Model.establish_connection(file)

    self
  end

  def self.run!
    require_relative 'application'
    Application.run!
  end

  def self.debug!
    self.debug = true
    self.run!
  end
end