# encoding: UTF-8

require_relative 'presenter'
require_relative 'p_squared_resolver'



class Resolver < PSquaredResolver

  # require resolvers
  Dir[PSquared.path+"/core/resolvers/*"].each do |file|
    require file
    use Object.const_get(File.basename(file, ".rb").capitalize+"Resolver")
  end

  not_found do
    resolve("error", "error_404", "The requested Page doesn't exist")
  end

end