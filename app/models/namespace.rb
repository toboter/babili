# t.integer   :subclass_id
# t.string    :subclass_type
# t.string    :name
# t.string    :slug

# t.timestamps

class Namespace < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  searchkick

  belongs_to :subclass, polymorphic: true
  has_many :repositories, dependent: :destroy
  has_many :schemes, class_name: 'Vocab::Scheme'

  before_validation { self.name = self.name.downcase }

  validates :name, presence: true
  validates :name, exclusion: { in: %w(vocabularies zensus locate users people organizations search about contact explore collections settings blog help news sidekiq api oauth research),
    message: "%{value} is reserved." }
  validates :name, format: { without: /^\d/, multiline: true}
  validates :name, length: { minimum: 3 }
  validates :name, format: { with: /\A[a-zA-Z0-9-]+\z/, message: "only allows letters, numbers and '-'." }
  validates :name, uniqueness: { case_sensitive: false }, on: :update

  scope :people, -> { where(subclass_type: 'Person') } 
  scope :organizations, -> { where(subclass_type: 'Organization') } 

  def accessors
    subclass_type == 'Person' ? [subclass] : subclass.members
  end

  def should_generate_new_friendly_id?
    name_changed? || super
  end

  def search_data
    {
      ns_name: name,
      name: subclass.try(:name)
    }
  end
end