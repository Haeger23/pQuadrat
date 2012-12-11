# encoding: UTF-8

class RequestResolver < PSquaredResolver

  # join project
  get %r{^/user/(\w+)/join/(\w+)/?$}i do |username, projectname|
    resolve("request", "join", username, projectname, params)
  end

  # join project
  post %r{^/user/(\w+)/join/(\w+)/?$}i do |username, projectname|
    # TODO another action
    #resolve("request", "join_action", username, projectname, params)
  end

  # invite to project
  get %r{^/project/(\w+)/invite/(\w+)/?$}i do |projectname, username|
    resolve("request", "invite", username, projectname)
  end

end