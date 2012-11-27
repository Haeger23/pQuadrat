# encoding: UTF-8

class UserResolver < PSquaredResolver

  # show dashboard
  get '/' do
    resolve("user", "dashboard", user)
  end

  # show users
  get %r{^/users/?$}i do
    resolve("user", "list")
  end

  # edit user, show user
  get %r{^/user/(\w+)/(edit|show)/?$}i do |username, action|
    resolve("user", action, username)
  end

  # show user
  get %r{^/user/(\w+)/?$}i do |username|
    resolve("user", "show", username)
  end

  # create user
  post %r{^/user/?$}i do
    resolve("user", "create", params)
  end

  # update user
  put %r{^/user/(\w+)/?$}i do |username|
    resolve("user", "update", user, username, params)
  end

  # delete user
  delete %r{^/user/(\w+)/?$}i do |username|
    resolve("user", "delete", user, username)
  end

  # update user, delete user (workaround for HTML5 forms)
  post %r{^/user/(\w+)/(update|delete)/?$}i do |username, action|
    resolve("user", action, username)
  end

end