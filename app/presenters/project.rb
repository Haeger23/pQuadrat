# encoding: UTF-8

class ProjectPresenter < Presenter

  def list
    view[:search] = "Projects"
    view[:projects] = Project.all(:order => "updated_at desc", :limit => 10)
  end

  def show title
    project = Project.find_by_title(title)
    stop(404, "There is no project with the title '#{title}'") unless project

    view[:title] = project.title
    view[:test] = "show project #{title}"
  end

  def add params
    view[:title] = "Add project"
  end

  def edit title
    view[:test] = "add project #{title}"
  end

  def create params
    # create user
  end

  def update title
    # update user
  end

  def delete title
    # delete user
  end

end