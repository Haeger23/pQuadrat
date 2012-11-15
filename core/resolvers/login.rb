# encoding: UTF-8

class LoginResolver < PSquaredResolver

  identify = -> do
    session = request.params["session"]
    if (not session.nil?) and session.length == 40
      PSquared.user = User.find_by_session(session)
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

  end

  # do login
  post %r{^/login/?$}i do

  end

  # show register
  get %r{^/register/?$}i do

  end


end