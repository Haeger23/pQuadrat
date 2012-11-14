# encoding: UTF-8

module PSquared
  PATH = File.expand_path('../', __FILE__)

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
    Dir["core/models/*"].each do |f|
      require_relative "../"+f
    end
    self
  end

  def self.run!
    require_relative 'resolver'

    Resolver.run!
  end
end