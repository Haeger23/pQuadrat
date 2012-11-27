# encoding: UTF-8

class ErrorPresenter < Presenter

  def error_400(message)
    status 400
    view[:message] = message
    view[:title] = "400 – Bad Request"
  end

  def error_403(message)
    status 403
    view[:message] = message
    view[:title] = "403 – Forbidden"
  end

  def error_404(message)
    status 404
    view[:message] = message
    view[:title] = "404 – Page not found"
  end

  def error_409(message)
    status 409
    view[:message] = message
    view[:title] = "409 – Conflict"
  end

  def no_view(locals)
    view[:title] = locals[:title]
    default = Presenter.default
    locals = locals.delete_if {|key, value| default.has_key?(key)}
    view[:vars] = locals
  end

end