class Mail
  require 'net/smtp'
  require 'mailit'

  mail = Mailit::Mail.new
  mail.to = 'test@test.com'
  mail.from = 'sender@sender.com'
  mail.subject 'Here are some files for you!'
  mail.text = 'This is what people with plain text mail readers will see'
  mail.html = 'A little something <b>special</b> for people with HTML readers'

  puts mail

end