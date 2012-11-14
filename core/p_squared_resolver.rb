require 'sinatra/base'

class PSquaredResolver < Sinatra::Base
  set :root, File.expand_path('../..', __FILE__)

  protected
  def resolve(presenter, action, *args)
    require_relative "../presenters/#{presenter}_presenter"
    presenterInstance = Object.const_get(presenter.capitalize+"Presenter").new
    presenterInstance.method(action.to_sym).call(*args)
    erb (presenter+"/"+action).to_sym, :locals => presenterInstance.view
  end
end