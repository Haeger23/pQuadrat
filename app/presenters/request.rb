# encoding: UTF-8

class RequestPresenter < Presenter

  def join username, projectname, params

    # TODO username muss auch noch codiert gültig sein sodass urls mit codierten usernames auch funktionieren

    #_user = User.find_by_url(username)
    #stop(404, "There is no user with the username '#{username}'") until _user

    require 'rubygems'
    require 'pony'
    Pony.mail(:to => 'willi.kampe@gmail.com', :from => 'admin@pquadrat.de', :subject => 'hi', :body => 'Hello there.')

    stop(403, "No username given") unless username
    stop(403, "No projectname given") unless projectname

    data[:username] = username
    data[:projectname] = projectname
  end

end