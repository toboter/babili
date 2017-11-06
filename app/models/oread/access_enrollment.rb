class Oread::AccessEnrollment < ApplicationRecord
  belongs_to :enrollee, class_name: 'User'
  belongs_to :application, class_name: 'Oread::Application'
  belongs_to :creator, class_name: 'User'

  validates :enrollee_id, :application_id, :creator_id, presence: true
  validates :enrollee_id, uniqueness: { scope: :application_id, message: "already enrolled" }
end
