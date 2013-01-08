# encoding: UTF-8

class RequestPresenter < Presenter

  def join username, projecturl, params
    _user, _project = validateInput(username, projecturl)
    # TODO username muss auch noch codiert gültig sein sodass urls mit codierten usernames auch funktionieren


    data[:sender_username] =  username
    data[:user] = _user
    data[:projecturl] = projecturl
    data[:project] = _project

    data_add(_user.attributes, "forename", "surname")

    data[:categories] = Category.all.map {|category| category.name}
    data[:skills] = _user.skills.map do |skill|
      {
          category: skill.category.name,
          skill: skill.name,
          weight: skill.weight
      }
    end

  end

  def join_action username, projectname, params
    _user, _project = validateInput(username, projectname)
    #_user = User.find_by_url(username)
    data[:sender_username] = username
    data[:sender_forename] =  _user.forename
    data[:sender_surname]  =  _user.surname
    data[:recipient_username] = 'Paule PO'
    data[:projectname] = projectname
    data[:mailto] = 'willi.kampe@gmail.com'


    #mail = MailSender.new('join', data)
    #data[:success] = MailSender.send('join', data)
  end

  def invite username, projecturl, params
    _user, _project = validateInput(username, projecturl)
    # TODO username muss auch noch codiert gültig sein sodass urls mit codierten usernames auch funktionieren


    data[:sender_username] =  username
    data[:user] = _user
    data[:projecturl] = projecturl
    data[:project] = _project

    data_add(_user.attributes, "forename", "surname")

    data[:categories] = Category.all.map {|category| category.name}
    data[:skills] = _user.skills.map do |skill|
      {
          category: skill.category.name,
          skill: skill.name,
          weight: skill.weight
      }
    end

  end

  def invite_action username, projectname, params
    _user, _project = validateInput(username, projectname)
    #_user = User.find_by_url(username)
    data[:sender_username] = username
    data[:sender_forename] =  _user.forename
    data[:sender_surname]  =  _user.surname
    data[:recipient_username] = 'Paule PO'
    data[:projectname] = projectname
    data[:mailto] = 'willi.kampe@gmail.com'


    #mail = MailSender.new('join', data)
    #data[:success] = MailSender.send('join', data)
  end

private

  def validateInput username, projecturl
    stop(404, "No username given") unless username
    _user = User.find_by_url(username)
    stop(404, "There is no user with the username '#{username}'") until _user

    stop(404, "No projectname given") unless projecturl
    _project = Project.find_by_url(projecturl)
    stop(404, "There is no project with the title '#{projecturl}'") unless _project

    return _user, _project
  end

end