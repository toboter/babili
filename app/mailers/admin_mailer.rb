class AdminMailer < ApplicationMailer
  default from: 'admin@babylon-online.org'
  
   def new_user_waiting_for_approval(user)
     @user = user
     @url  = users_url
     @recipients = User.where(is_admin: true)
     emails = @recipients.collect(&:email).join(",")
     mail(to: emails, subject: 'New user awaiting approval.')
   end
end