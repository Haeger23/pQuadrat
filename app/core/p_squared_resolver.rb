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
        src = "#{request.base_url}/js/#{file}.js"
        newJs << "<script type='text/javascript' src='#{src}'></script>"
      end
      @js = newJs | @js
      @js.join("\n")
    end
    def css(*args)
      out = ""
      args.each do |file|
        out << "<link rel='stylesheet' type='text/css' href='#{request.base_url}/css/#{file}.css'></link>\n"
      end
      out
    end
  end

protected
  def resolve(presenter, action, *args)
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
    @presenter = presenter
    @locals = Presenter.do(presenter, action, @format, *args)
    pass unless @locals

    begin
      erb((@presenter+"/"+action+"."+@format).to_sym, :locals => @locals, :layout => (request.xhr? ? false : ("../layout/layout."+@format).to_sym))
    rescue Errno::ENOENT => e
      if @format == "json"
        JSON.generate @locals
      else
        @locals.to_xml(:root => "data")
      end
      #puts "view '#{e.message.split("/")[-2..-1].join("/")}' not available"
    end
  end
end