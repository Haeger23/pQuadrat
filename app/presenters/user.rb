# encoding: UTF-8

class UserPresenter < Presenter

  def initialize
    super
    @step = 10
  end

  def dashboard user
    page[:title] = "Dashboard"
  end

  def list(pageNumber)
    data[:count] = User.count
    data[:page_count] = data[:count] > 0 ? 1+(data[:count]-1)/@step : 1
    data[:page] = pageNumber
    stop(404, "There is no user list ##{pageNumber}, last user is ##{data[:page_count]}") if data[:page] > data[:page_count]

    data[:users] = User.all(
        :order => "updated_at desc",
        :offset => @step*(pageNumber-1),
        :limit => @step
    )

    page[:title] = "Users"
    page[:search] = "Users"
  end

  def show user, username
    _user = User.find_by_url(username)
    stop(404, "There is no user with the username '#{username}'") until _user

    data[:ownAccount] = (user and user.id == _user.id)

    page[:title] = _user.username
    data[:image] = _user.image.url
    data[:skills] = _user.skills.collect do |skill|
      category = skill.category
      {name: skill.name, category: category.name, value: skill.weight, url: "skill/#{category.url}/#{skill.url}"}
    end

    data[:projects] = _user.projects

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
          if not projects.has_key?(project.id)
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

    data[:skills] = []
    user.skills.map do |skill|
      data[:skills].push({
        category: skill.category,
        skill: skill.name,
        weight: skill.weight
      })
    end

    data[:image] = user.image.url
    data_add(user.attributes, "id", "username", "mail", "birthday", "forename", "surname", "website", "image_file_name", "about", "url")
    data[:projects] = user.projects
  end

  def create params
    feedback!(User.create_with_hash(params, "username", "password", "mail"))
  end

  def validate params
    if params[:id].nil?
      user = User.new_with_hash(params, "username", "password", "mail")
    else
      user = User.find_by_id(params[:id])
      stop(404, "There is no user with the id #{params[:id]}") until user
      user.fill_with_hash(params, "username", "password", "mail", "image", "forename", "surname", "birthday", "website")
    end
    feedback(user)
  end

  def update user, params
    stop(403, "Only a logged in user can update the account") until user

    old_url = user.url

    if params["image"].blank?
      params["image"] = nil
    elsif not (params["image_file"].nil? or params["image_file"].blank?)
      params["image"] = params["image_file"][:tempfile]
    else
      params.delete("image")
    end

    p params
    feedback!(user.update_with_hash(params, "username", "password", "mail", "image", "forename", "surname", "birthday", "website"))

    if old_url != user.url
      data[:old_url] = old_url
      data[:new_url] = user.url
    end
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