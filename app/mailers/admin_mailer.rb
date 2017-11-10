class AdminMailer < ApplicationMailer
  default from: 'admin@babylon-online.org'
  
  def new_user_waiting_for_approval(user)
    @user = user
    @url  = users_url
    @recipients = User.where(is_admin: true)
    emails = @recipients.collect(&:email).join(",")
    mail(to: emails, subject: '[babylon-online.org] New user is awaiting approval.')
  end

  def new_membership_awaiting_verification(membership)
    @applicant = membership.user
    @project = membership.project
    @url  = edit_settings_project_url(@project)
    @recipients = @project.members.joins(:memberships).where(memberships: {role: ['Owner', 'Admin']}).uniq
    emails = @recipients.collect(&:email).join(",")
    mail(to: emails, subject: "[babylon-online.org][Project: #{@project.name}] User is awaiting membership verification.")
  end
end