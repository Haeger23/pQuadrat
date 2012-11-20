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
      out = erb((@presenter+"/"+view.to_s+"."+@format).to_sym, options)
      @presenter = currentPresenter
      @locals = currentLocals
      out
    end
    def js(*args)
      @js ||= []
      newJs = []
      args.each do |file|
        if(file[0] == "/")
          src = "#{settings.public_folder}/#{file[1..-1]}.js"
        else
          src = "#{settings.views}/#{@presenter}/#{file}.js"
        end
        newJs << "<script type='text/javascript' src='#{src}'></script>"
      end
      @js = newJs | @js
      @js.join("\n")
    end
    def css(*args)
      out = ""
      args.each do |file|
        out << "<link rel='stylesheet' type='text/css' href='#{settings.public_folder}/#{file}.css'></link>\n"
      end
      out
    end
  end

protected
  def resolve(presenter, action, *args)
    # find requested format
    request.preferred_type(%w[text/html application/json application/x-json text/json text/x-json application/xml text/xml])
    if request.accept? "text/html"
      @format = "html"
    elsif request.accept? "application/json" or request.accept? "application/x-json" or request.accept? "text/json" or request.accept? "text/x-json"
      @format = "json"
    elsif request.accept? "application/xml" or request.accept? "text/xml"
      @format = "xml"
    else
      @format = "html"
    end

    options = args.extract_options!
    require_relative "../presenters/#{presenter}"
    if Object.respond_to?((presenter.capitalize+"Presenter").to_sym)
      presenterInstance = Object.const_get(presenter.capitalize+"Presenter").new
      @locals = presenterInstance.view
    else
      presenterInstance = nil
      @locals = {}
    end
    @presenter = presenter

    if presenterInstance.respond_to?(action.to_sym)
      begin
        method = presenterInstance.method(action.to_sym)
        method.call(*args)
      rescue ResolverStoppedError
        pass
        return
      end
    end

    actionSym = (action+"_"+@format).to_sym
    if presenterInstance.respond_to?(actionSym)
      begin
        method = presenterInstance.method(actionSym)
        method.call(*args)
      rescue ResolverStoppedError
        pass
        return
      end
    end

    begin
      erb((@presenter+"/"+action+"."+@format).to_sym, :locals => @locals, :layout => ("layout."+@format).to_sym)
    rescue Errno::ENOENT => e
      puts "view '#{e.message.split("/")[-2..-1].join("/")}' not available"
    end

  end
end