# encoding: UTF-8

class RequestPresenter < Presenter

  def join user, projecturl, params
    stop(403, "Only a logged in user can join a project") unless user
    project = Project.find_by_url(projecturl)
    stop(404, "There is no project with the title '#{projecturl}'") unless project

    page[:title] = "Join Project #{project.title}"
    page[:breadcrumb] = [{url: "projects", title: "Projects"}, {url: "project/#{projecturl}", title: project.title}]

    data[:sender_username] = user.username
    data[:projecturl] = projecturl
    data[:project] = project

    data_add(user.attributes, "forename", "surname")

    data[:categories] = Category.all.map {|category| category.name}
    data[:skills] = user.skills.map do |skill|
      {
          category: skill.category.name,
          skill: skill.name,
          weight: skill.weight
      }
    end

  end

  def join_action user, projecturl, params
    stop(403, "Only a logged in user can join a project") unless user
    project = Project.find_by_url(projecturl)
    stop(404, "There is no project with the title '#{projecturl}'") unless project

    request = Request.find_by_user_id_and_project_id(user.id, project.id)
    if request
      if request.is_invitation
        feedback!(UserProject.create(
            user: user,
            project: project,
            weight: params["weight"] || 50
        ))
        request.delete
      end
      return
    end

    feedback!(Request.create(
        user: user,
        project: project,
        message: params["message"],
        is_invitation: false
    ))

    data[:sender_username] = user.username
    data[:sender_forename] =  user.forename
    data[:sender_surname]  =  user.surname
    data[:recipient_username] = 'Paule PO'
    data[:projectname] = project.title
    data[:mailto] = 'willi.kampe@gmail.com'


    #mail = MailSender.new('join', data)
    #data[:success] = MailSender.send('join', data)
  end


  def leave user, projecturl, params
    stop(403, "Only a logged in user can leave a project") unless user
    project = Project.find_by_url(projecturl)
    stop(404, "There is no project with the title '#{projecturl}'") unless project

    userProject = UserProject.find_by_user_id_and_project_id(user.id, project.id)
    userProject.delete if userProject

    page[:title] = "Leave Project #{project.title}"
    page[:breadcrumb] = [{url: "projects", title: "Projects"}, {url: "project/#{projecturl}", title: project.title}]

    data[:sender_username] = user.username
    data[:projecturl] = projecturl
    data[:project] = project

  end


  def leave_action user, projecturl, params
    stop(403, "Only a logged in user can leave a project") unless user
    project = Project.find_by_url(projecturl)
    stop(404, "There is no project with the title '#{projecturl}'") unless project

    request = Request.find_by_user_id_and_project_id(user.id, project.id)
    if request
      request.delete
    end

    userProject = UserProject.find_by_user_id_and_project_id(user.id, project.id)
    userProject.delete if userProject
  end

  def invite user, username, projecturl, params
    stop(403, "Only a logged in user can invite a user to a project") unless user
    _user, _project = validateInput(username, projecturl)

    page[:title] = "Invite <b>#{_user.username}</b> to Project <b>#{_project.title}</b>"
    page[:breadcrumb] = [{url: "users", title: "Users"}, {url: "user/#{username}", title: _user.username}]

    data[:sender_username] =  username
    data[:userImage] = _user.image.url(:medium)
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

  def invite_action user, username, projectname, params
    stop(403, "Only a logged in user can invite a user to a project") unless user
    _user, _project = validateInput(username, projectname)

    request = Request.find_by_user_id_and_project_id(_user.id, _project.id)
    if request
      unless request.is_invitation
        feedback!(UserProject.create(
            user: _user,
            project: _project,
            weight: params["weight"] || 50
        ))
        request.delete
      end
      return
    end

    feedback!(Request.create(
        user: _user,
        project: _project,
        message: params["message"],
        is_invitation: true
    ))

    data[:sender_username] = username
    data[:sender_forename] =  _user.forename
    data[:sender_surname]  =  _user.surname
    data[:recipient_username] = 'Paule PO'
    data[:projectname] = projectname
    data[:mailto] = 'willi.kampe@gmail.com'

    #mail = MailSender.new('join', data)
    #data[:success] = MailSender.send('join', data)
  end

  def decline_action user, username, projectname, params
    stop(403, "Only a logged in user can decline a user request") unless user
    _user, _project = validateInput(username, projectname)

    request = Request.find_by_user_id_and_project_id(_user.id, _project.id)
    if request
      request.delete
      return
    end

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