# encoding: UTF-8

class Presenter

  attr_reader :view

  def initialize
    @view = {
        title: "p squared"
    }
  end

  def stop
    raise ResolverStoppedError.new "Stopped Presenter"
  end

  def title str
    @view["title"] = str
  end
end