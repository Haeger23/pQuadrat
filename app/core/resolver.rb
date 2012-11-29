# encoding: UTF-8

require_relative 'presenter'
require_relative 'p_squared_resolver'



class Resolver < PSquaredResolver

  # require resolvers
  [
      "login",
      "user",
      "project",
      "request",
      "search",
      "debug",
      "contact",
      "help"
  ].each do |resolver|
    require PSquared.path+"/core/resolvers/#{resolver}.rb"
    use Object.const_get(resolver.capitalize+"Resolver")
  end

  not_found do
    resolve("error", "error_404", "The requested Page doesn't exist")
  end

end