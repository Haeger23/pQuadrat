# encoding: UTF-8

class RequestResolver < Resolver

  # join project
  get %r{^/user/(\w+)/join/(\w+)/?$}i do |username, projectname|
    resolve("request", "join", username, projectname, params)
  end

  # action to join project
  post %r{^/user/(\w+)/join/(\w+)/?$}i do |username, projectname|
    # TODO another action
    resolve("request", "join_action", username, projectname, params)
  end

  # invite to project
  get %r{^/project/(\w+)/invite/(\w+)/?$}i do |projectname, username|
    resolve("request", "invite", username, projectname, params)
  end

  # action to invite to project
  post %r{^/project/(\w+)/invite/(\w+)/?$}i do |projectname, username|
    resolve("request", "invite_action", username, projectname, params)
  end

end