# encoding: UTF-8

module PSquared
  PATH = File.expand_path('../', __FILE__)

  gem 'activerecord'
  gem 'mysql'
  gem 'sinatra'

  require 'active_record'
  require 'mysql'
  require 'yaml'
  require_relative 'presenter'
  require_relative 'resolver'

  def self.run!
    Resolver.run!
  end
end