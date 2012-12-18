# encoding: UTF-8

class RequestPresenter < Presenter

  def join username, projectname, params

    # TODO username muss auch noch codiert gültig sein sodass urls mit codierten usernames auch funktionieren

    #_user = User.find_by_url(username)
    #stop(404, "There is no user with the username '#{username}'") until _user

    stop(403, "No username given") unless username
    stop(403, "No projectname given") unless projectname

    data[:sender_username] = username
    data[:projectname] = projectname
  end

  def join_action username, projectname, params

    stop(403, "No username given") unless username
    stop(403, "No projectname given") unless projectname

    data[:sender_username] = username
    data[:recipient_username] = 'Paule'
    data[:projectname] = projectname
    data[:mailto] = 'willi.kampe@gmail.com'


    #mail = MailSender.new('join', data)
    data[:success] = MailSender.send('join', data)
  end

end