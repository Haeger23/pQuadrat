# encoding: UTF-8

class UserPresenter < Presenter

  def dashboard
    view["test"] = "show #{"admin " if PSquared.user}dashboard"
  end

  def list
    view["search"] = "Users"
    view["users"] = User.all(:order => "updated_at desc", :limit => 10)
  end

  def show username
    user = User.find_by_username(username)
    stop until user

    view["title"] = user.username
    view["username"] = user.username
  end

  def add username
    view["test"] = "add user #{username.downcase}"
  end

  def edit username
    view["test"] = "add user #{username.downcase}"
  end

  def create username, params
    begin
      User.create!(
          username: username,
          password: params[:password],
          mail: params[:mail]
      )
    rescue Exception => e
      halt 400, e.message
    end
  end

  def update username
    # update user
  end

  def delete username
    # delete user
  end

end