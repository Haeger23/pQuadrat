# encoding: UTF-8

class ProjectResolver < PSquaredResolver

  # show projects
  get %r{^/projects/?$}i do
    resolve("project", "list")
  end

  # show project
  get %r{^/project/(\w+)/?$}i do |title|
    resolve("project", "show", title)
  end

  get %r{^/project/(\w+)/(show|add|edit)/?$}i do |title, action|
    resolve("project", action, title)
  end

  # create project
  post %r{^/project/(\w+)/?$}i do |title|
    resolve("project", "create", title)
  end

  # update project
  put %r{^/project/(\w+)/?$}i do |title|
    resolve("project", "update", title)
  end

  # delete user
  delete %r{^/project/(\w+)/?$}i do |title|
    resolve("project", "delete", title)
  end

  # update user, delete user (workaround for HTML5 forms)
  post %r{^/project/(\w+)/(update|delete)/?$}i do |title, action|
    resolve("project", action, title)
  end

end