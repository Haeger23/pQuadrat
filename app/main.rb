# encoding: UTF-8
Encoding.default_external = "UTF-8"

require_relative 'core/p_squared'
PSquared
  .initializeDatabase("database_dev.yml")
  .debug!