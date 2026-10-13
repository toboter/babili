class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.FROM
  layout 'mailer'
end
