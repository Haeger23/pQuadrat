# encoding: UTF-8

require_relative 'presenter'
require_relative 'p_squared_resolver'

# require resolvers
Dir["core/resolvers/*"].each do |file|
  require_relative "../"+file
end

class Resolver < PSquaredResolver

  use UserResolver
  use ProjectResolver

  not_found do
    erb :not_found
  end

end