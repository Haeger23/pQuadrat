# encoding: UTF-8

require 'sinatra/base'

class PSquaredResolver < Sinatra::Base
  set :root, File.expand_path('../..', __FILE__)

  protected
  def resolve(presenter, action, *args)
    require_relative "../presenters/#{presenter}"
    presenterInstance = Object.const_get(presenter.capitalize+"Presenter").new
    method = presenterInstance.method(action.to_sym)
    begin
      method.call(*args)
      erb((presenter+"/"+action).to_sym, :locals => presenterInstance.view)
    rescue Exception => exception
      p exception
      pass
    end
  end
end