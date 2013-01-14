# encoding: UTF-8

class ProjectPresenter < Presenter

  def init
    @step = 10
  end

  def list(pageNumber = 1)
    data[:count] = Project.count
    data[:page_count] = data[:count] > 0 ? 1+(data[:count]-1)/@step : 1
    data[:page] = pageNumber
    stop(404, "There is no project list ##{pageNumber}, last project list is ##{data[:page_count]}") if data[:page] > data[:page_count]

    data[:projects] = Service["project"].serve!("projects_for_page", pageNumber, @step)

    page[:title] = "Projects"
    page[:search] = "Projects"
  end

  def list_json(pageNumber = 1)
    data[:projects] = data[:projects].collect {|project| project.attributes}
  end

  def list_xml(pageNumber = 1)
    list_json(pageNumber)
  end

  def validate(user, params)
    stop(403, "Only a logged in user can edit the project") unless user

    feedback(Project.new_with_hash(params, "title", "about", "progress"))
  end

  def validate_existing(user, url, params)
    project = Project.find_by_url(title)
    stop(404, "There is no project with the url '#{url}'") unless project
    stop(403, "Only a logged in user can validate the project") unless user

    projectUser = UserProject.find_by_user_id_and_project_id(user.id, project.id)
    stop(403, "Only a project-member can validate this project") unless projectUser
    stop(403, "Only a project-administrator can validate this project") unless projectUser.is_admin

    feedback(project.fill_with_hash(params, "title", "progress", "about"))
  end

  def show(user, title, params)
    project = Project.find_by_url(title)
    stop(404, "There is no project with the title '#{title}'") unless project

    page[:title] = project.title
    page[:breadcrumb] = [{url: "projects", title: "Projects"}]

    data["image"] = project.image.url
    data["hasProject"] = false
    data["hasJoinRequest"] = false
    data["users"] = project.users
    data["skills"] = project.skills.collect do |skill|
      category = skill.category
      {name: skill.name, category: category.name, value: skill.weight, url: "skill/#{category.url}/#{skill.url}"}
    end
    if user
      userProject = UserProject.find_by_user_id_and_project_id(user.id, project.id)

      if userProject
        data["hasProject"] = true
        data["isAdmin"] = userProject.is_admin
      else
        userJoinRequest = Request.find_by_user_id_and_project_id_and_is_invitation(user.id, project.id, false)
        if userJoinRequest
          data["hasJoinRequest"] = true
        end
      end
    end

    data_add(project.attributes, "title", "url", "about", "progress", "created_at")
  end

  def add(user, params)
    stop(403, "Only a logged in user can add a project") unless user
    page[:title] = "Add project"
  end

  def edit(user, url)
    project = Project.find_by_url(url)
    stop(404, "There is no project with the url '#{url}'.") unless project
    stop(403, "Only a logged in user can edit the project") unless user

    projectUser = UserProject.find_by_user_id_and_project_id(user.id, project.id)
    stop(403, "Only a project-member can edit this project") unless projectUser
    stop(403, "Only a project-administrator can edit this project") unless projectUser.is_admin

    page[:title] = "Edit Project"
    page[:breadcrumb] = [{url: "projects", title: "Projects"}, {url: "project/#{project.url}", title: project.title}]

    data[:categories] = Category.all.map {|category| category.name}
    data[:skills] = project.skills.map do |skill|
      {
          category: skill.category.name,
          skill: skill.name,
          weight: skill.weight
      }
    end

    data["image"] = project.image.url
    data_add(project.attributes, "title", "url", "about", "progress", "image_file_name")
    data["users"] = project.users
  end

  def create(user, params)
    stop(403, "Only a logged in user can add a project") unless user
    project = feedback!(Project.create_with_hash(params, "title", "progress", "about"))
    UserProject.create(
        project: project,
        user: user,
        weight: 50,
        is_admin: true
    )
    status(201)
  end

  def update(user, url, params)
    project = Project.find_by_url(url)
    stop(404, "No project #{url} available") until project
    stop(403, "Only a logged in user can update the account") until user

    projectUser = UserProject.find_by_user_id_and_project_id(user.id, project.id)
    stop(403, "Only a project-member can edit this project") unless projectUser
    stop(403, "Only a project-administrator can edit this project") unless projectUser.is_admin

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
        projectSkill = ProjectSkill.where(project_id: project.id, skill_id: skill.id).first_or_create(weight: v["weight"])
        if projectSkill
          projectSkill.weight = v["weight"]
          projectSkill.save
          skills.push(projectSkill)
        end
      end
    end
    params["project_skills"] = skills

    feedback!(project.update_with_hash(params, "progress", "about", "project_skills"))
    status(201)
  end

  def delete(user, title)
    # todo delete project
  end

  def all_validators
    data[:validators] = Project.validators_as_hash
  end

  def validators(attribute)
    data[:validators] = Project.validators_as_hash_on(attribute)
  end

end