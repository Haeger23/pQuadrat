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
    page[:title] = "API"
    data_add(Presenter["help"].serve!("api"))
    data[:urls] = data[:api].map { |help| help[0] }.uniq
  end

end