class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :project
  
  validates :role, presence: true
  
  def is_owner?
    role == 'Owner'
  end
end
