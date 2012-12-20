# encoding: UTF-8

class ProjectPresenter < Presenter

  def list pageNumber
    step = 10
    data[:page_count] = 1 + Project.count/step
    data[:page] = pageNumber
    stop(404, "There is no project list ##{pageNumber}, last user is ##{data[:page_count]}") if data[:page] > data[:page_count]

    data[:projects] = Project.all(
        :order => "updated_at desc",
        :offset => step*(pageNumber-1),
        :limit => step
    )

    page[:title] = "Projects"
    page[:search] = "Projects"
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

  def edit title
    data[:test] = "add project #{title}"
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