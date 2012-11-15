# encoding: UTF-8

class DebugPresenter < Presenter

  def user_add args
    p args
    User.first_or_create!(
      username: args["username"],
      password: "secret",
      mail: "valid@email.de"
    )
  end

end