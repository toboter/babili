# t.integer "namespace_id"
# t.string "name"
# t.text "description"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.integer "creator_id"

class Repository < ApplicationRecord
  extend FriendlyId
  friendly_id :name, :use => :scoped, :scope => :owner
  acts_as_ordered_taggable_on :topics

  belongs_to :owner, class_name: 'Namespace', foreign_key: :namespace_id
  belongs_to :creator, class_name: 'Person'
  
  has_many :events, class_name: 'Aggregation::Event', dependent: :destroy # ... data_events
  has_many :upload_events, class_name: 'Aggregation::Event::UploadEvent', dependent: :destroy

  has_many :commits, through: :events, class_name: 'Aggregation::Commit'
  has_many :items, class_name: 'Aggregation::Item'

  has_many :referencations, class_name: 'Biblio::Referencation', dependent: :destroy
  has_many :references, through: :referencations, class_name: 'Biblio::Entry', source: :entry

  validates :name, 
    presence: true
  validates :name, 
    uniqueness: { 
      scope: :namespace_id, 
      message: 'should be unique to your namespace'
    }
  validates :name, 
    exclusion: { 
      in: %w(vocabularies people search repositories applications lists),
      message: "%{value} is reserved."
    }

end