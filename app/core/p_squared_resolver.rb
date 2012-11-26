# encoding: UTF-8

require 'sinatra/base'

class PSquaredResolver < Sinatra::Base
  set :root, File.expand_path('../..', __FILE__)

  before do
    # find requested format
    request.accept.each do |value|
      if value == "text/html"
        @format = "html"
        break
      elsif value == "application/json" or value == "application/x-json" or value == "text/json" or value == "text/x-json"
        @format = "json"
        break
      elsif value == "application/xml" or value == "text/xml"
        @format = "xml"
        break
      end
    end
    @format ||= "html"
  end

  helpers do
    def view(view, locals={}, *args)
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
        if file[0] == "/"
          path = "#{file[1..-1]}.js"
        else
          path = "js/#{file}.js"
        end
        newJs << "<script type='text/javascript' src='#{request.base_url}/#{path}'></script>"
      end
      @js = newJs | @js
      @js.join("\n")
    end
    def css(*args)
      out = ""
      args.each do |file|
        if file[0] == "/"
          path = "#{file[1..-1]}.css"
        else
          path = "css/#{file}.css"
        end
        out << "<link rel='stylesheet' type='text/css' href='#{request.base_url}/#{path}'></link>\n"
      end
      out
    end
    def less(*args)
      out = ""
      args.each do |file|
        if file[0] == "/"
          path = "#{file[1..-1]}.less"
        else
          path = "less/#{file}.less"
        end
        out << "<link rel='stylesheet/less' type='text/css' href='#{request.base_url}/#{path}'></link>\n"
      end
      out
    end
    def link href, title
      "<a href='#{request.base_url}/#{href}'>#{title}</a>"
    end
    def keys
      @locals.keys.sort
    end
  end

protected
  def resolve(presenter, action, *args)
    @presenter = presenter
    begin

      instance = Presenter.do!(presenter, action, @format, *args)

      if instance
        @locals = instance.view
        if instance.current_status
          status instance.current_status
        end
      else
        @locals = Presenter.default.clone
      end
    rescue PresenterPassedError
      pass
      return
    rescue PresenterStoppedError => e
      return resolve("error", "error_"+e.status.to_s, e.message)
    end

    begin
      @user = PSquared.user
      erb((@presenter+"/"+action+"."+@format).to_sym, :locals => @locals, :layout => (request.xhr? ? false : ("layout."+@format).to_sym))
    rescue Errno::ENOENT => e
      if @format == "html"
        return resolve("error", "no_view", @locals)
      end

      default = Presenter.default
      @locals = @locals.clone.delete_if {|key, value| default.has_key?(key)}

      if @format == "json"
        JSON.generate @locals
      elsif @format == "xml"
        @locals.to_xml(:root => "data")
      end
    end
  end
end