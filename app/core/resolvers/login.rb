# encoding: UTF-8

class LoginResolver < PSquaredResolver

  identify = -> do
    session = request.params["session"]
    if (not session.nil?) and session.length == 40
      # get the user with the given session, if the session is newer than 1 hour
      user = User.find_by_session(session, :conditions => ["created_at > ?", DateTime.now - Rational(60, 86400)])
      if user
        user.session_will_change
        user.save()
      end
    end
    pass
  end

  # do identification
  get    '*', &identify
  post   '*', &identify
  put    '*', &identify
  delete '*', &identify

  # show login
  get %r{^/login/?$}i do
    resolve("login", "login")
  end

  # do login
  post %r{^/login/?$}i do
    username, password = request.params["username"], request.params["password"]
    pass if username.nil? or password.nil?
    resolve("login", "create_session", username, password)
  end



  # show register
  get %r{^/registration/?$}i do
    resolve("user", "add", params)
  end


end