# encoding: UTF-8

class LoginPresenter < Presenter

  def login
    page[:title] = "Login"
    # todo show login
  end

  def logout
    page[:title] = "Logout"
    # todo show logout
  end

  def create_session(params)
    username, password = params["username"], params["password"]
    stop(400, "No username given") unless username
    stop(400, "No password given") unless password

    user = User.login(username, password)
    stop(400, "Wrong username or password") unless user

    require "digest/sha1"
    chars = ("a".."z").to_a
    var = 16.times.to_a.collect { chars[rand(26)] }.join("")
    user.session = Digest::SHA1.hexdigest(user.id.to_s + var)
    user.save

    data[:session] = user.session
  end

  def delete_session user
    stop(403, "Only a logged in user can logout") until user

    user.session = nil
    user.save
  end

  def registration
    # todo do registration
  end

end