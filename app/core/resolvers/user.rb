# encoding: UTF-8

class UserResolver < PSquaredResolver

  # show dashboard
  get '/' do
    resolve("user", "dashboard")
  end

  # show users
  get %r{^/users/?$}i do
    resolve("user", "list")
  end

  # show user
  get %r{^/user/(\w+)/?$}i do |username|
    resolve("user", "show", username)
  end

  # add user, edit user, show user
  get %r{^/user/(\w*)/(add|edit|show)/?$}i do |username, action|
    resolve("user", action, username)
  end

  # create user
  post %r{^/user/(\w+)/?$}i do |username|
    resolve("user", "create", username, params)
  end

  # update user
  put %r{^/user/(\w+)/?$}i do |username|
    resolve("user", "update", username)
  end

  # delete user
  delete %r{^/user/(\w+)/?$}i do |username|
    resolve("user", "delete", username)
  end

  # update user, delete user (workaround for HTML5 forms)
  post %r{^/user/(\w+)/(update|delete)/?$}i do |username, action|
    resolve("user", action, username)
  end

end