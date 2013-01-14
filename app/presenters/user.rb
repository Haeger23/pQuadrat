# encoding: UTF-8

class UserPresenter < Presenter

  def init
    @step = 10
  end

  def dashboard(user)
    page[:title] = "Home"

    data[:users] = get("user").serve!("list")
    data[:projects] = get("project").serve!("list")

    data[:invitations] = []
    data[:requests] = Hash.new {|h,k| h[k] = {projects: []}}
    data[:openInvitations] = Hash.new {|h,k| h[k] = {projects: []}}
    data[:openRequests] = []
    if user
      user.projects.each do |project|
        if project.is_admin
          project.requests.each do |request|
            unless request.is_invitation
              data[:requests][request.user_id][:user] = request.user
              data[:requests][request.user_id][:projects].push({message: request.message, project: request.project})
            else
              data[:openInvitations][request.user_id][:user] = request.user
              data[:openInvitations][request.user_id][:projects].push({message: request.message, project: request.project})
            end
          end
        end
      end
      user.requests.each do |request|
        if request.is_invitation
          data[:invitations].push(request)
        else
          data[:openRequests].push(request)
        end
      end
    end

  end

  def list(pageNumber = 1)
    data[:count] = User.count
    data[:page_count] = data[:count] > 0 ? 1+(data[:count]-1)/@step : 1
    data[:page] = pageNumber
    stop(404, "There is no user list ##{pageNumber}, last user is ##{data[:page_count]}") if data[:page] > data[:page_count]

    data[:users] = Service["user"].serve!("users_for_page", pageNumber, @step)

    page[:title] = "Users"
    page[:search] = "Users"
  end

  def list_json(pageNumber = 1)
    data[:users] = data[:users].collect {|user| user.attributes.delete_if {|k,v| k == "password"} }
  end

  def list_xml(pageNumber = 1)
    list_json(pageNumber)
  end

  def show(user, username)
    _user = User.find_by_url(username)
    stop(404, "There is no user with the username '#{username}'") until _user

    data[:ownAccount] = (user and user.id == _user.id)

    page[:title] = _user.username
    page[:breadcrumb] = [{url: "users", title: "Users"}]

    data[:image] = _user.image.url
    data[:skills] = _user.skills.collect do |skill|
      category = skill.category
      {name: skill.name, category: category.name, value: skill.weight, url: "skill/#{category.url}/#{skill.url}"}
    end

    data[:projects] = _user.projects
    data[:requests] = {}
    _user.requests.each {|request| data[:requests][request.project_id] = request}

    data_add(_user.attributes, "id", "username", "mail", "birthday", "forename", "surname", "website", "image_file_name", "about", "url")

    data[:invitations] = []
    data[:excludes] = []
    data[:same_projects] = {}
    if user and user.id != _user.id
      projects = {}
      data[:projects].each do |project|
        projects[project.id] = project
      end

      user.projects.each do |project|
        if project.is_admin
          next if data[:requests].has_key?(project.id)
          unless projects.has_key?(project.id)
            data[:invitations].push(project)
          else
            data[:same_projects][project.id] = projects[project.id]
            unless projects[project.id].is_admin
              data[:excludes].push(projects[project.id])
            end
          end
        end
      end
    end
  end

  def add params
    page[:title] = "Registration"
  end

  def edit user, username
    stop(403, "Only a logged in user can update the account") until user
    stop(403, "You only can update your account") until user.url.downcase == username.downcase

    page[:title] = "Edit your profile"
    page[:breadcrumb] = [{url: "users", title: "Users"}, {url: "user/#{user.url}", title: user.username}]

    data[:categories] = Category.all.map {|category| category.name}
    data[:skills] = user.skills.map do |skill|
      {
        category: skill.category.name,
        skill: skill.name,
        weight: skill.weight
      }
    end

    data[:image] = user.image.url
    data_add(user.attributes, "id", "username", "mail", "birthday", "forename", "surname", "website", "image_file_name", "about", "url")
    data[:projects] = user.projects
  end

  def create params
    feedback!(User.create_with_hash(params, "username", "password", "mail"))
    status(201)
  end

  def validate user, params
    unless user
      user = User.new_with_hash(params, "username", "password", "mail")
    else
      user.fill_with_hash(params, "username", "password", "mail", "image", "forename", "surname", "birthday", "website")
    end
    feedback(user)
  end

  def update user, params
    stop(403, "Only a logged in user can update the account") until user

    empty_to_nil(params)

    if params["image"].blank?
      params["image"] = nil
    elsif not (params["image_file"].nil? or params["image_file"].blank?)
      params["image"] = params["image_file"][:tempfile]
    else
      params.delete("image")
    end

    skills = []
    (params["skills"] || {}).each do |k,v|
      category = Category.find_by_name(v["category"])
      next unless category

      skill = Skill.where(name: v["name"], category_id: category.id).first_or_create
      if skill
        userSkill = UserSkill.where(user_id: user.id, skill_id: skill.id).first_or_create(weight: v["weight"])
        if userSkill
          userSkill.weight = v["weight"]
          userSkill.save
          skills.push(userSkill)
        end
      end
    end
    params["user_skills"] = skills

    feedback!(user.update_with_hash(params, "password", "mail", "image", "forename", "surname", "birthday", "website", "about", "user_skills"))
    status(201)
  end

  def delete user, username
    stop(403, "Only a logged in user can delete the account") until user
    stop(403, "You only can delete your account") until user.username.downcase == username.downcase

    user.delete
  end

  def all_validators
    data[:validators] = User.validators_as_hash
  end

  def validators(attribute)
    data[:validators] = User.validators_as_hash_on(attribute)
  end

end