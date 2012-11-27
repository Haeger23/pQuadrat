# encoding: UTF-8

class UserPresenter < Presenter

  def dashboard user
    view[:test] = "show #{"admin " if user}dashboard"
  end

  def list
    view[:search] = "Users"
    view[:users] = User.all(:order => "updated_at desc", :limit => 10)
  end

  def show username
    user = User.find_by_username(username)
    stop(404, "There is no user with the username '#{username}'") until user

    view[:title] = user.username
    to_view(user.attributes, "username", "forename", "surname")
  end

  def add params
    view[:title] = "Add user"
  end

  def edit username
    view[:test] = "edit user #{username.downcase}"
  end

  def create params
    begin
      User.create!(
          username: params[:username],
          password: params[:password],
          mail: params[:mail]
      )
    rescue Exception => e
      stop(400, e.message)
    end
  end

  def update user, username, params
    stop(403, "Only a logged in user can update the account") until user
    stop(403, "You only can update your account") until user.username.downcase == username.downcase

    user.update_with_hash(params, :username, :password, :mail, :image, :forename, :surname, :birthday)
  end

  def delete user, username
    stop(403, "Only a logged in user can delete the account") until user
    stop(403, "You only can delete your account") until user.username.downcase == username.downcase

    user.delete
  end

end