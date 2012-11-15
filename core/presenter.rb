# encoding: UTF-8

class Presenter

  attr_reader :view

  def initialize
    @view = {}
  end

  def stop
    throw Exception.new "Stopped Presenter"
  end
end