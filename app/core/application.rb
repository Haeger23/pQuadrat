# encoding: UTF-8

require_relative 'service'
require_relative 'presenter'
require_relative 'resolver'



class Application < Resolver

  # require resolvers
  [
      "login",
      "user",
      "project",
      "request",
      "skill",
      "search",
      "debug",
      "contact",
      "help",
      "admin"
  ].each do |resolver|
    require PSquared.path+"/core/resolvers/#{resolver}.rb"
    use Object.const_get(resolver.capitalize+"Resolver")
  end

  not_found do
    resolve("error", "error_404", "The requested Page doesn't exist")
  end

end