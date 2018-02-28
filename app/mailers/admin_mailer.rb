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
    @applicant = membership.person
    @organization = membership.organization
    @url  = edit_settings_organization_url(@organization)
    @recipients = @organization.members.joins(:memberships).where(memberships: {role: 'Admin'}).uniq
    emails = @recipients.collect(&:email).join(",")
    mail(to: emails, subject: "[babylon-online.org][Team: #{@organization.name}] User is awaiting membership verification.")
  end
end