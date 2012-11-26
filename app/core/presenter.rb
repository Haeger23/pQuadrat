# encoding: UTF-8

class PresenterPassedError < StandardError
end

class PresenterStoppedError < StandardError
  attr_reader :status
  def initialize(status, msg = "An error on the server occured...")
    super msg
    @status = status
  end
end

class Presenter
  include Enumerable

  @@default = {
    title: "p squared",
    search: "All",
    query: ""
  }
  attr_reader :current_status
  attr_reader :status
  attr_reader :view

  def initialize
    @view = @@default.clone
  end

  def self.default
    @@default.clone
  end

  def init *args
  end

  def self.do!(presenter, action, format, *args)
    begin
      require PSquared.path+"/presenters/#{presenter}"
      instance = Object.const_get(presenter.capitalize+"Presenter").new
      locals = instance.view
    rescue LoadError
      return nil
    end

    instance.init *args

    if instance.respond_to?(action.to_sym)
      method = instance.method(action.to_sym)
      method.call(*args)
    end

    if format
      actionSym = (action+"_"+format).to_sym
      if instance.respond_to?(actionSym)
        method = instance.method(actionSym)
        method.call(*args)
      end
    end

    return instance
  end

  def self.do(presenter, action, format, *args)
    begin
      self.do!(presenter, action, format, *args)
    rescue
      nil
    end
  end

  def self.collect(presenter, action, format, *args, &block)
    if instance = self.do(presenter, action, format, *args)
      instance.each &block
    else
      {}
    end
  end

  def each(&block)
    if block_given?
      @view.each &block
    else
      @view
    end
  end

  def to_view(hash, *args)
    args.each { |k| view[k] = hash[k] }
  end

protected
  def pass
    raise PresenterPassedError.new("Passed Presenter")
  end

  def stop(status, message)
    raise PresenterStoppedError.new(status, message)
  end

  def status(int)
    @current_status = int
  end

end