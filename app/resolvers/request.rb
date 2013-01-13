# encoding: UTF-8

class RequestResolver < ViewResolver

  # join project
  get %r{^/project/(\w+)/join/?$}i do |projectname|
    resolve("request", "join", user, projectname, params)
  end

  # action to join project
  post %r{^/project/(\w+)/join/?$}i do |projectname|
    resolve("request", "join_action", user, projectname, params)
  end

  # leave project
  get %r{^/project/(\w+)/leave/?$}i do |projectname|
    resolve("request", "leave", user, projectname, params)
  end

  # leave project
  post %r{^/project/(\w+)/leave/?$}i do |projectname|
    resolve("request", "leave_action", user, projectname, params)
  end

  # invite to project
  get %r{^/project/(\w+)/invite/(\w+)/?$}i do |projectname, username|
    resolve("request", "invite", user, username, projectname, params)
  end

  # action to invite to project
  post %r{^/project/(\w+)/invite/(\w+)/?$}i do |projectname, username|
    resolve("request", "invite_action", user, username, projectname, params)
  end

  # action to decline to project
  post %r{^/project/(\w+)/decline/(\w+)/?$}i do |projectname, username|
    resolve("request", "decline_action", user, username, projectname, params)
  end

end