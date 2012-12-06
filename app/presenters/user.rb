# encoding: UTF-8

class UserPresenter < Presenter

  def dashboard user
    data[:test] = "show #{"admin " if user}dashboard"
  end

  def list
    page[:search] = "Users"
    data[:users] = User.all(:order => "updated_at desc", :limit => 10)
  end

  def show user, username
    _user = User.find_by_url(username)
    stop(404, "There is no user with the username '#{username}'") until _user

    data[:ownAccount] = (user and user.id == _user.id)

    page[:title] = _user.username
    data_add(_user.attributes, "username", "forename", "surname")
  end

  def add params
    page[:title] = "Add user"
  end

  def edit user, username
    stop(403, "Only a logged in user can update the account") until user
    stop(403, "You only can update your account") until user.url.downcase == username.downcase

    page[:title] = "Edit your profile"

    data[:skills] = []
    user.skills.map do |skill|
      data[:skills].push({
        category: skill.category,
        skill: skill.name,
        weight: skill.weight
      })
    end

    data_add(user.attributes, "username", "mail", "birthday", "forename", "surname", "website")
  end

  def create params
    feedback(User.create(
        username: params[:username],
        password: params[:password],
        mail: params[:mail]
    ))
  end

  def update user, params
    stop(403, "Only a logged in user can update the account") until user

    old_url = user.url

    feedback(user.update_with_hash(params, :username, :password, :mail, :image, :forename, :surname, :birthday, :website))

    if old_url != user.url
      data[:old_url] = old_url
      data[:new_url] = user.url
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