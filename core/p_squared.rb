# encoding: UTF-8

module PSquared
  class << self
    attr_accessor :user, :debug, :path
  end

  self.user = false
  self.debug = false
  self.path = File.expand_path "..", __FILE__

  gem 'activerecord'
  gem 'mysql'
  gem 'sinatra'

  def self.initializeDatabase(file)
    require 'active_record'
    require 'mysql'
    require 'yaml'

    # initialize database
    dbConfig = YAML::load(File.open(File.expand_path(file)))
    ActiveRecord::Base.establish_connection(dbConfig)

    # load models
    Dir["models/*"].each do |f|
      require_relative "../"+f
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
    self.run!
  end
end