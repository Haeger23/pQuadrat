# encoding: UTF-8

module PSquared
  class << self
    attr_accessor :user, :debug, :path
  end

  self.user = nil
  self.debug = false
  self.path = File.expand_path "../..", __FILE__

  gem 'activerecord'
  gem 'mysql'
  gem 'sinatra'

  def self.initializeDatabase(file)
    require 'active_record'
    require 'mysql'
    require 'yaml'  # YAML is a human friendly data serialization standard
    require 'json'
    require 'builder' # for creating XML markup and data structures

    # initialize database
    dbConfig = YAML::load(File.open(PSquared.path+"/"+file))
    ActiveRecord::Base.establish_connection(dbConfig)

    require PSquared.path+"/core/model"
    # load models
    Dir[PSquared.path+"/models/*"].each do |f|
      require f
    end

    self
  end

  def self.run!
    require_relative 'resolver'
    Resolver.run!
  end

  def self.debug!
    require_relative 'resolver'
    self.debug = true
    # WK ISSUE "require_relative 'resolver'" seems to be executed twice, problem?
    self.run!
  end
end