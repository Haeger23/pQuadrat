# encoding: UTF-8

class UserPresenter < Presenter

  def dashboard user
    data[:test] = "show #{"admin " if user}dashboard"
  end

  def list
    page[:search] = "Users"
    data[:users] = User.all(:order => "updated_at desc", :limit => 10)
  end

  def show username
    user = User.find_by_username(username)
    stop(404, "There is no user with the username '#{username}'") until user

    page[:title] = user.username
    data_add(user.attributes, "username", "forename", "surname")
  end

  def add params
    page[:title] = "Add user"
  end

  def edit username
    data[:test] = "edit user #{username.downcase}"
  end

  def create params
    user = User.create(
        username: params[:username],
        password: params[:password],
        mail: params[:mail]
    )
    if user.invalid?
      data[:errors] = user.errors.to_hash
      stop(400, user.errors.full_messages.join(", "))
    end
  end

  def update user, username, params
    stop(403, "Only a logged in user can update the account") until user
    stop(403, "You only can update your account") until user.username.downcase == username.downcase

    user.update_with_hash(params, :username, :password, :mail, :image, :forename, :surname, :birthday)
    if user.invalid?
      data[:errors] = user.errors.to_hash
      stop(400, user.errors.full_messages.join(", "))
    end
  end

  def delete user, username
    stop(403, "Only a logged in user can delete the account") until user
    stop(403, "You only can delete your account") until user.username.downcase == username.downcase

    user.delete
  end

  def all_validators
    data[:validators] = User.validators_as_hash
  end

  def validators(attribute)
    data[:validators] = User.validators_as_hash_on(attribute)
  end

end