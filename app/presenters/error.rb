# encoding: UTF-8

class ErrorPresenter < Presenter

  def init *args
    view["title"] = "page not found"
  end

end