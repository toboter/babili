# t.integer   :subclass_id
# t.string    :subclass_type
# t.string    :name
# t.string    :slug

# t.timestamps

class Namespace < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :subclass, polymorphic: true

  before_validation { self.name = self.name.downcase }

  validates :name, presence: true
  validates :name, exclusion: { in: %w(vocabularies zensus locate users people organizations search about contact explore collections settings blog help news sidekiq api oauth),
    message: "%{value} is reserved." }
  validates :name, format: { without: /^\d/, multiline: true}
  validates :name, length: { minimum: 3 }
  validates :name, format: { with: /\A[a-zA-Z0-9-]+\z/, message: "only allows letters, numbers and '-'." }
  validates :name, uniqueness: { case_sensitive: false }, on: :update

  scope :people, -> { where(subclass_type: 'Person') } 
  scope :organizations, -> { where(subclass_type: 'Organization') } 

  def should_generate_new_friendly_id?
    name_changed? || super
  end

end