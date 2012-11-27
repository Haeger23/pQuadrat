# encoding: UTF-8

class LoginPresenter < Presenter

  def login
    # show login
  end

  def create_session(params)
    username, password = params["username"], params["password"]
    stop(403, "No username given") unless username
    stop(403, "No password given") unless password

    user = User.login(username, password)
    stop(403, "Wrong username or password") unless user

    require "digest/sha1"
    chars = ("a".."z").to_a
    var = 16.times.to_a.collect { chars[rand(26)] }.join("")
    user.session = Digest::SHA1.hexdigest(user.id.to_s + var)
    user.save

    view[:session] = user.session
  end

  def registration
    # do registration
  end

end