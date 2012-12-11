# encoding: UTF-8

class PresenterPassedError < StandardError
  attr_reader :data
  attr_reader :page

  def initialize(data, page, msg = "Presenter passed")
    super msg
    @data, @page = data, page
  end
end

class PresenterStoppedError < StandardError
  attr_reader :status
  attr_reader :data
  attr_reader :page

  def initialize(status, data, page, msg = "An error on the server occured...")
    super msg
    @status, @data, @page = status, data, page
  end
end

class Presenter
  include Enumerable


  attr_reader :current_status
  attr_reader :data
  attr_reader :page

  def initialize
    @data = {}
    @page = {}

    #include MailSender

  end

  def init *args
  end

  def self.do!(presenter, action, format, *args)
    presenter.downcase!
    action.downcase!

    begin
      require PSquared.path+"/presenters/#{presenter}"
      instance = Object.const_get(presenter.capitalize+"Presenter").new
      locals = instance.data
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
    rescue StandardError => error
      p error
      nil
    end
  end

  def self.collect(presenter, action, *args, &block)
    if instance = self.do(presenter, action, nil, *args)
      instance.each &block
    else
      {}
    end
  end

  def each(&block)
    if block_given?
      @data.each &block
    else
      @data
    end
  end

  def data_add(hash, *args)
    if args.length > 0
      args.each { |k| data[k] = hash[k] }
    else
      data.merge!(hash)
    end
  end

protected
  def pass
    raise PresenterPassedError.new(data, page)
  end

  def stop(status, message)
    raise PresenterStoppedError.new(status, data, page, message)
  end

  def status(int)
    @current_status = int
  end

  def feedback(activeRecord)
    if activeRecord.invalid?
      data[:errors] = activeRecord.errors.to_hash
      stop(400, activeRecord.errors.full_messages.join(", "))
    else
      activeRecord
    end
  end

end