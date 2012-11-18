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
    @presenter = presenter
    @locals = presenterInstance.view

    begin
      if presenterInstance.respond_to?(action.to_sym)
        method = presenterInstance.method(action.to_sym)
        method.call(*args)
      end
    rescue ResolverStoppedError
      pass
      return
    end

    begin
      request.preferred_type(%w[text/html application/json application/x-json text/json text/x-json application/xml text/xml])
      if request.accept? "text/html"
        format = "html"
      elsif request.accept? "application/json" or request.accept? "application/x-json" or request.accept? "text/json" or request.accept? "text/x-json"
        format = "json"
      elsif request.accept? "application/xml" or request.accept? "text/xml"
        format = "xml"
      else
        format = "html"
      end

      actionSym = (action+"_"+format).to_sym
      if presenterInstance.respond_to?(actionSym)
        method = presenterInstance.method(actionSym)
        method.call(*args)
      end
      erb((@presenter+"/"+action+"."+format).to_sym, :locals => @locals, :layout => ("layout."+format).to_sym)
    rescue ResolverStoppedError
      pass
      return
    rescue Errno::ENOENT => e
      puts "view '#{e.message.split("/")[-2..-1].join("/")}' not available"
    end

  end
end