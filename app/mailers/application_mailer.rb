class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.FROM
  layout 'mailer'
end
