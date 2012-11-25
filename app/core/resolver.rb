# encoding: UTF-8

require_relative 'presenter'
require_relative 'p_squared_resolver'

# require resolvers
Dir[PSquared.path+"/core/resolvers/*"].each do |file|
  require file
end

class Resolver < PSquaredResolver

  use LoginResolver
  use SearchResolver
  use UserResolver
  use ProjectResolver
  use DebugResolver

  not_found do
    resolve("error", "error_404", "The requested Page doesn't exist")
  end

end