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

    data[:projects] = Service["project"].serve("all", pageNumber, @step)

    page[:title] = "Projects"
    page[:search] = "Projects"
  end

  def list_json(pageNumber = 1)
    data[:projects] = data[:projects].collect {|project| project.attributes}
  end

  def list_xml(pageNumber = 1)
    list_json(pageNumber)
  end

  def validate params
    if params[:id].nil?
      project = Project.new_with_hash(params, "title", "about", "progress")
    else
      project = Project.find_by_id(params[:id])
      stop(404, "There is no project with the id #{params[:id]}") until project
      project.fill_with_hash(params, "title", "progress", "about")
    end
    feedback(project)
  end

  def show user, title, params
    project = Project.find_by_url(title)
    stop(404, "There is no project with the title '#{title}'") unless project

    page[:title] = project.title
    page[:breadcrumb] = [{url: "projects", title: "Projects"}]

    data["image"] = project.image.url
    data["hasProject"] = false
    if user
      userProject = UserProject.find_by_user_id_and_project_id(user && user.id, project.id)

      if userProject
        data["hasProject"] = true
        data["isAdmin"] = userProject.is_admin
      end
    end

    data_add(project.attributes, "title", "url", "about", "progress")
  end

  def add params
    page[:title] = "Add project"
  end

  def edit user, url
    stop(403, "Only a logged in user can edit the project") unless user
    project = Project.find_by_url(url)
    stop(404, "There is no project with the url '#{url}'.") unless project

    projectUser = UserProject.find_by_user_id_and_project_id(user.id, project.id)
    stop(403, "Only a project-member can edit this project") unless projectUser
    stop(403, "Only a project-administrator can edit this project") unless projectUser.is_admin

    page[:title] = "Edit Project"
    page[:breadcrumb] = [{url: "projects", title: "Projects"}, {url: "project/#{project.url}", title: project.title}]

    data[:test] = "Edit project #{project.title}"
  end

  def create params
    # todo create user
  end

  def update title
    # todo update user
  end

  def delete title
    # todo delete user
  end

  def all_validators
    data[:validators] = Project.validators_as_hash
  end

  def validators(attribute)
    data[:validators] = Project.validators_as_hash_on(attribute)
  end

end