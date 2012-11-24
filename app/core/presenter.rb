# encoding: UTF-8

class PresenterStoppedError < StandardError
end

class Presenter

  @@default = {
    title: "p squared",
    search: "All",
    query: ""
  }
  attr_reader :view

  def initialize
    @view = @@default.clone
  end

  def init *args
  end

  def stop
    raise PresenterStoppedError.new "Stopped Presenter"
  end

  def self.do(presenter, action, format, *args)
    begin
      require PSquared.path+"/presenters/#{presenter}"
      instance = Object.const_get(presenter.capitalize+"Presenter").new
      locals = instance.view
    rescue LoadError
      return @@default.clone
    end

    instance.init *args

    if instance.respond_to?(action.to_sym)
      begin
        method = instance.method(action.to_sym)
        method.call(*args)
      rescue PresenterStoppedError
        return false
      end
    end

    actionSym = (action+"_"+format).to_sym
    if instance.respond_to?(actionSym)
      begin
        method = instance.method(actionSym)
        method.call(*args)
      rescue PresenterStoppedError
        return false
      end
    end

    return locals
  end
end