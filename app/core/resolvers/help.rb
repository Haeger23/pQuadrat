# encoding: UTF-8

class HelpResolver < Resolver

  get %r{^/help/?$}i do
    resolve("help", "overview", request.params)
  end

  get %r{^/help/api/?$}i do
    resolve("help", "api")
  end

  get %r{^/help/development/?$}i do
    resolve("help", "development")
  end

  get %r{^/help/models/?$}i do
    resolve("help", "models")
  end

  get %r{^/help/models/development/?$}i do
    resolve("help", "models_development")
  end

  get %r{^/help/views/?$}i do
    resolve("help", "views")
  end

  get %r{^/help/views/development/?$}i do
    resolve("help", "views_development")
  end

  get %r{^/help/views/helper/?$}i do
    resolve("help", "views_helper")
  end

  get %r{^/help/views/templates/?$}i do
    resolve("help", "views_templates")
  end

  get %r{^/help/models/?$}i do
    resolve("help", "models")
  end

  get %r{^/help/presenters/?$}i do
    resolve("help", "presenters")
  end

  get %r{^/help/presenters/development/?$}i do
    resolve("help", "presenters")
  end

end