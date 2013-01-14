# encoding: UTF-8
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require_relative 'core/p_squared'
PSquared
  .initializeDatabase("database_dev.yml")
  .debug!