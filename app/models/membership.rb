class Membership < ApplicationRecord
  belongs_to :person
  belongs_to :organization

  after_create :send_admin_mail
  after_update :send_confirmation_mail, if: :is_verified?
  
  validates :role, presence: true
  validates :person_id, uniqueness: { scope: :organization_id, message: "is already on the list" }
  
  def is_admin?
    role == 'Admin'
  end

  def send_admin_mail
    AdminMailer.new_membership_awaiting_verification(self).deliver
  end

  def send_confirmation_mail
    UserMailer.membership_confirmed(self).deliver
  end

  private
  def is_verified?
    verified_changed? && verified?
  end
end
