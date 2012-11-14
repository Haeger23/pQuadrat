class UserPresenter < Presenter

  def dashboard
    view["test"] = "show dashboard"
  end

  def show username
    user = User.find_by_username(username)
    stop until user
    view["test"] = "show user #{user.username}"
  end

  def add username
    view["test"] = "add user #{username.downcase}"
  end

  def edit username
    view["test"] = "add user #{username.downcase}"
  end

  def create username
    User.create(
        username: username,
        password: username,
        mail: "ff026@hdm-stuttgart.de"
    )
  end

  def update username
    # update user
  end

  def delete username
    # delete user
  end

end