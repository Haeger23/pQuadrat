# encoding: UTF-8

class ProjectPresenter < Presenter

  def list
    page[:search] = "Projects"
    data[:projects] = Project.all(:order => "updated_at desc", :limit => 10)
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
    # create user
  end

  def update title
    # update user
  end

  def delete title
    # delete user
  end

end