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
    resolve("user", action, user, username)
  end

  # show user
  get %r{^/user/(\w+)/?$}i do |username|
    resolve("user", "show", user, username)
  end

  # create user
  post %r{^/user/?$}i do
    resolve("user", "create", params)
  end

  # update user
  put %r{^/user/?$}i do
    resolve("user", "update", user, params)
  end

  # delete user
  delete %r{^/user/(\w+)/?$}i do |username|
    resolve("user", "delete", user, username)
  end

  # update user, delete user (workaround for HTML5 forms)
  post %r{^/user/(\w+)/(update|delete)/?$}i do |username, action|
    resolve("user", action, username)
  end

  # get all validators
  get %r{^/users/validators/?$}i do
    resolve("user", "all_validators")
  end

  # get validators of attribute
  get %r{^/users/validators/(\w+)/?$}i do |attribute|
    resolve("user", "validators", attribute)
  end

end