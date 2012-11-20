# encoding: UTF-8

class LoginPresenter < Presenter

  def login
    # show login
  end

  def create_session(username, password)
    user = User.login(username, password)
    stop unless user

    require "digest/sha1"
    var = ""
    chars = ("a".."z").to_a
    16.times.each { var << chars[rand(26)] }
    user.session = Digest::SHA1.hexdigest(user.id.to_s + var)
  end

  def register
    # do registration
  end

end