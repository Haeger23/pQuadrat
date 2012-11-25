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
    view[:help] = [
      ["users", "GET", ""],
      ["projects", "GET", ""],
      ["search/all", "GET", "query"],
      ["search/users", "GET", "query"],
      ["search/projects", "GET", "query"],
    ]
  end

end