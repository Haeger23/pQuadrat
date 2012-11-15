# encoding: UTF-8

require 'sinatra/base'

class PSquaredResolver < Sinatra::Base
  set :root, File.expand_path('../..', __FILE__)

  helpers do
    def template(view, locals={}, *args)
      currentPresenter = @presenter
      currentLocals = @locals
      options = args.extract_options!
      options.merge!(:layout => false, :locals => @locals.merge(locals))
      out = erb((@presenter+"/"+view.to_s).to_sym, options)
      @presenter = currentPresenter
      @locals = currentLocals
      return out
    end
  end

protected
  def resolve(presenter, action, *args)
    options = args.extract_options!
    require_relative "../presenters/#{presenter}"
    presenterInstance = Object.const_get(presenter.capitalize+"Presenter").new
    method = presenterInstance.method(action.to_sym)
    begin
      method.call(*args)
      @presenter = presenter
      @locals = presenterInstance.view
      erb((@presenter+"/"+action).to_sym, :locals => @locals)
    rescue ResolverStoppedError
      pass
    rescue Errno::ENOENT => e
      puts "view '#{e.message.split("/")[-2..-1].join("/")}' not available"
      pass
    end
  end
end