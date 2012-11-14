class UserPresenter < Presenter

  def dashboard
    view["test"] = "show dashboard"
  end

  def show username
    view["test"] = "show user #{username.downcase}"
  end

  def add username
    view["test"] = "add user #{username.downcase}"
  end

  def create username
    # create user
  end

  def update username
    # update user
  end

  def delete username
    # delete user
  end

end