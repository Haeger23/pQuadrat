class MailSender
  require 'rubygems'
  require 'pony'

  attr_accessor :action, :params

  def initialize(action, params)
    @action = action
    @params = params
  end

  def send
    Pony.mail(:to => 'willi.kampe@gmail.com', :from => 'admin@pquadrat.de', :subject => 'Aktion: ' + action, :body => 'Hello there.')
  end

end