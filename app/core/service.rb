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

  def self.[](service)
    service.to_s.downcase!

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

  def serve!(action, *args, &block)
    action = action.to_s.downcase.to_sym

    if self.respond_to?(action)
      method = self.method(action)
      @data = method.call(*args)
      self.each &block
    else
      @data
    end

  end

  def do!(action, *args, &block)
    self.serve!(action, *args, &block)
    self
  end

end

class NilService < Service
end