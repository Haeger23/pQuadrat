class MailSender
  require 'rubygems'
  require 'pony'
  require 'erb'


  def self.send action, params
    template_path = PSquared.path+"/views/template/mail/"

    case action
      when 'join'
        subject = 'pQuadrat - ' + params[:sender_username] + ' moechte Ihrem Projekt beitreten'
        body = ERB.new File.new( template_path + "join_project.erb").read, nil, "%<>"
      when 'invite'
        subject = 'pQuadrat - Anfrage Projektbeitritt'
    end

    return Pony.mail(:to => params[:mailto], :from => 'admin@pquadrat.de', :subject => subject, :body => body.result(binding))
  end

end