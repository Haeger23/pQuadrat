# encoding: UTF-8

class RequestPresenter < Presenter

  def join(username, projectname, params)
    stop(403, "No username given") unless username
    stop(403, "No projectname given") unless projectname
  end

end