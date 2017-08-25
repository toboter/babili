class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :project
  
  validates :role, presence: true
  validates :user_id, uniqueness: { scope: :project_id, message: "is already on the list" }
  
  def is_owner?
    role == 'Owner'
  end
end
