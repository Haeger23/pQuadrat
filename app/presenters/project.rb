# encoding: UTF-8

class ProjectPresenter < Presenter

  def list
    page[:title] = "Projects"
    page[:search] = "Projects"
    data[:projects] = Project.all(:order => "updated_at desc", :limit => 10)
  end

  def validate params
    if params[:id].nil?
      project = Project.new(
          title: params[:title],
          about: params[:about],
          progress: params[:progress]
      )
    else
      project = Project.find_by_id(params[:id])
      stop(404, "There is no project with the id #{params[:id]}") until project
      project.fill_with_hash(params, :title, :progress, :about)
    end
    feedback(project)
  end

  def show title
    project = Project.find_by_title(title)
    stop(404, "There is no project with the title '#{title}'") unless project

    page[:title] = project.title
    data[:test] = "show project #{title}"
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