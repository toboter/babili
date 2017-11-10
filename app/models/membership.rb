class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :project

  after_create :send_admin_mail
  
  validates :role, presence: true
  validates :user_id, uniqueness: { scope: :project_id, message: "is already on the list" }
  
  def is_owner?
    role == 'Owner'
  end

  def send_admin_mail
    AdminMailer.new_membership_awaiting_verification(self).deliver
  end
end
