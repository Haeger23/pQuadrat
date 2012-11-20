# encoding: UTF-8

class ProjectPresenter < Presenter

  def show title
    view["test"] = "show project #{title}"
  end

  def add title
    view["test"] = "add project #{title}"
  end

  def edit title
    view["test"] = "add project #{title}"
  end

  def create title
    # create user
  end

  def update title
    # update user
  end

  def delete title
    # delete user
  end

end