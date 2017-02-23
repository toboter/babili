class OreadAccessibility < ApplicationRecord
  belongs_to :oread_application, class_name: 'Oread::Application', foreign_key: 'oread_application_id'
  belongs_to :project

  validates :oread_application_id, :project_id, :creator_id, presence: true
  validates :oread_application_id, uniqueness: { scope: :project_id }
end
