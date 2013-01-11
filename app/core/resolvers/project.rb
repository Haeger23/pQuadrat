# encoding: UTF-8

class ProjectResolver < Resolver

  # show projects
  get %r{^/projects/?$}i do
    resolve("project", "list", 1)
  end

  # show projects
  get %r{^/projects/(\d+)/?$}i do |page|
    resolve("project", "list", page.to_i)
  end

  # show project
  get %r{^/project/(\w+)/?$}i do |project|
    resolve("project", "show", user, project, params)
  end

  # add project to projects
  get %r{^/projects/add/?$}i do
    resolve("project", "add", params)
  end

  # edit project, show project
  get %r{^/project/(\w+)/(edit|show)/?$}i do |title, action|
    resolve("project", action, user, title)
  end

  # create project
  post %r{^/project/?$}i do
    resolve("project", "create", params)
  end

  # create project
  post %r{^/project/validate/?$}i do
    resolve("project", "validate", params)
  end

  # update project
  put %r{^/project/?$}i do |title|
    resolve("project", "update", title)
  end

  # delete user
  delete %r{^/project/?$}i do |title|
    resolve("project", "delete", title)
  end

  # update user, delete user (workaround for HTML5 forms)
  post %r{^/project/(update|delete)/?$}i do |action|
    resolve("project", action, params)
  end

  # get all validators
  get %r{^/projects/validators/?$}i do
    resolve("project", "all_validators")
  end

  # get validators of attribute
  get %r{^/projects/validators/(\w+)/?$}i do |attribute|
    resolve("project", "validators", attribute)
  end

end