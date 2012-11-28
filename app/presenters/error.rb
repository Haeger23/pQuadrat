# encoding: UTF-8

class ErrorPresenter < Presenter

  def error_400(message)
    status 400
    data[:message] = message
    page[:title] = "400 – Bad Request"
  end

  def error_403(message)
    status 403
    data[:message] = message
    page[:title] = "403 – Forbidden"
  end

  def error_404(message)
    status 404
    data[:message] = message
    page[:title] = "404 – Page not found"
  end

  def error_409(message)
    status 409
    data[:message] = message
    page[:title] = "409 – Conflict"
  end

end