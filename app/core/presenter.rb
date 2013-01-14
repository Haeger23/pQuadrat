# encoding: UTF-8

class PresenterError < StandardError
  attr_reader :data
  attr_reader :page

  def initialize(data, page, msg = "An error on the server occured...")
    super msg
    @data, @page = data, page
  end
end

class PresenterPassedError < PresenterError
end

class PresenterStoppedError < PresenterError
  attr_reader :status

  def initialize(status, data, page, msg = "An error on the server occured...")
    super data, page, msg
    @status = status
  end
end

class Presenter < Service

  #include MailSender
  require PSquared.path+"/core/mail_sender.rb"

  attr_reader :current_status
  attr_reader :page

  def initialize(format = nil)
    super()
    @page = {}
    @format = format
  end

  def serve!(action, *args, &block)
    action = action.downcase.to_sym

    if self.respond_to?(action)
      method = self.method(action)
      method.call(*args)
    end
    if @format
      action = (action.to_s+"_"+@format.to_s).to_sym
      if self.respond_to?(action)
        method = self.method(action)
        method.call(*args)
      end
    end
    self.each &block
  end

  def self.[](presenter, format=nil)
    presenter.downcase!

    begin
      require PSquared.path+"/presenters/#{presenter}"
      clazz = Object.const_get(presenter.capitalize+"Presenter")
    rescue LoadError
      clazz = NilPresenter
    end
    instance = clazz.new(format)
    instance.init
    instance
  end

  def get(presenter)
    self.class[presenter, @format]
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
    data[:errors] = activeRecord.invalid? ? activeRecord.errors.to_hash : {}
    activeRecord
  end

  def feedback!(activeRecord)
    if activeRecord.invalid?
      data[:errors] = activeRecord.errors.to_hash
      stop(400, activeRecord.errors.full_messages.join(", "))
    else
      activeRecord
    end
  end

  def empty_to_nil(hash)
    hash.each do |k,v|
      if(v.respond_to?(:split) and v.split.empty?)
        hash[k] = nil
      end
    end
  end

end

class NilPresenter < Presenter
end