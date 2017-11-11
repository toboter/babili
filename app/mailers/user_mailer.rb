class UserMailer < ApplicationMailer
  default from: 'admin@babylon-online.org'
  
  def account_approved(user)
    @user = user
    @url  = new_user_session_url
    email = @user.email
    mail(to: email, subject: '[babylon-online.org] Your account has been approved.')
  end

  def membership_confirmed(membership)
    @applicant = membership.user
    @project = membership.project
    @url  = settings_projects_url
    email = @applicant.email
    mail(to: email, subject: "[babylon-online.org][Project: #{@project.name}] Your membership has been confirmed.")
  end
end