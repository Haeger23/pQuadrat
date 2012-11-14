# encoding: UTF-8

require_relative 'core/p_squared'
PSquared
  .initializeDatabase("database.yml")
  .run!