# encoding: UTF-8

require_relative 'presenter'
require_relative 'p_squared_resolver'

# require resolvers
Dir[PSquared.path+"/core/resolvers/*"].each do |file|
  require file
end

class ResolverStoppedError < StandardError
end

class Resolver < PSquaredResolver

  use LoginResolver
  use UserResolver
  use ProjectResolver
  use DebugResolver

  not_found do
    erb :"../layout/not_found.html"
  end

end