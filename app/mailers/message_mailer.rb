class MessageMailer < ApplicationMailer
  default from: 'contact@babylon-online.org'
  
  def contact(message)
    @name = message.name
    @from = message.email
    @body = message.body
    @sent_at = message.sent_at
    to = 'contact@babylon-online.org'
    mail(to: to, subject: "[babylon-online.org] Message from #{@name}.")
  end

  def receipt(message)
    @name = message.name
    @from = message.email
    @body = message.body
    @sent_at = message.sent_at
    to = @from
    mail(to: to, subject: "[babylon-online.org] Your message receipt.")
  end
end