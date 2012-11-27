# encoding: UTF-8

class LoginResolver < PSquaredResolver

  before do
    env["user"] = nil
    session = request.params["session"]
    if (not session.nil?) and session.length == 40
      # get the user with the given session, if the session is newer than 30 minutes
      env["user"] = user = User.find_by_session(session, :conditions => ["updated_at > ?", DateTime.now - Rational(1, 48)])
      if user
        user.session_will_change!
        user.save()
      end
    end
    pass
  end

  # show login
  get %r{^/login/?$}i do
    resolve("login", "login")
  end

  # do login
  post %r{^/login/?$}i do
    resolve("login", "create_session", params)
  end



  # show register
  get %r{^/registration/?$}i do
    resolve("user", "add", params)
  end


end