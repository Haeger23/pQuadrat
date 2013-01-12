# encoding: UTF-8

require_relative 'service'
require_relative 'presenter'
require_relative 'resolver'
require_relative '../view_resolver'



class Application < ViewResolver

  # require resolvers
  YAML.load(File.open(PSquared.path+"/resolvers.yml")).each do |resolver|
    filename = PSquared.path+"/resolvers/#{resolver}.rb"
    if File.exist?(filename)
      require filename
      use Object.const_get(resolver.capitalize+"Resolver")
    end
  end

  not_found do
    resolve("error", "error_404", "The requested Page doesn't exist")
  end

end