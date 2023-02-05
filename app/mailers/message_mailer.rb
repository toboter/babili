class MessageMailer < ApplicationMailer
  default from: Rails.application.secrets.FROM

  def contact(message)
    @name = message.name
    @from = message.email
    @body = message.body
    @sent_at = message.sent_at
    to = Rails.application.secrets.TO
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
