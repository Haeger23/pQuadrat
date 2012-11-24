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
  use ErrorResolver

  not_found do
    p request
    resolve("error", "not_found")
  end

end