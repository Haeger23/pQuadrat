# encoding: UTF-8

class DebugPresenter < Presenter

  def user_add args
    User.first_or_create!(
      username: args["username"],
      password: "secret",
      mail: "valid@email.de"
    )
  end

  def api
    view[:title] = "API"
    to_view(Presenter.collect("help", "api", nil))
    view[:urls] = view[:api].map { |help| help[0] }.uniq
  end

end