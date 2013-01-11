class Service
  include Enumerable

  attr_reader :data

  def initialize
    @data = {}
  end

  def init *args
  end

  def each(&block)
    if block_given?
      @data.each &block
    else
      @data
    end
  end

  def self.get(service)
    service.downcase!

    begin
      require PSquared.path+"/services/#{service}"
      clazz = Object.const_get(service.capitalize+"Service")
    rescue LoadError
      clazz = NilService
    end
    instance = clazz.new
    instance.init
    instance
  end

  def self.serve(service, action, *args, &block)
    self.get(service).serve(action, *args, &block)
  end

  def self.collect(presenter, action, *args, &block)
    self.serve(presenter, action, *args, &block)
  end

  def self.do(service, action, *args, &block)
    service = self.get(service)
    service.serve(action, *args, &block)
    service
  end

  def serve(action, *args, &block)
    action = action.downcase.to_sym

    if self.respond_to?(action)
      method = self.method(action)
      method.call(*args)
    end
    @data.each &block
  end

end

class NilService < Service
end