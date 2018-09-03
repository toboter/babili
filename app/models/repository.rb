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

  def should_generate_new_friendly_id?
    name_changed? || super
  end

  belongs_to :owner, class_name: 'Namespace', foreign_key: :namespace_id
  belongs_to :creator, class_name: 'Person'

  has_many :invited_collaborations, as: :collaboratable, dependent: :destroy, class_name: 'Collaboration'
  has_many :invited_collaborators, through: :invited_collaborations, source: :collaborator

  has_many :documents, dependent: :destroy, class_name: 'Writer::Document'
  
  has_many :events, class_name: 'Aggregation::Event', dependent: :destroy # ... data_events
  has_many :upload_events, class_name: 'Aggregation::Event::UploadEvent', dependent: :destroy

  has_many :commits, through: :events, class_name: 'Aggregation::Commit'
  has_many :items, class_name: 'Aggregation::Item'

  has_many :referencations, class_name: 'Biblio::Referencation', dependent: :destroy
  has_many :references, through: :referencations, class_name: 'Biblio::Entry', source: :entry

  has_many :threads, as: :discussable, class_name: 'Discussion::Thread'

  delegate :accessors, to: :owner

  validates :name, :description,
    presence: true
    
  validates :name, 
    uniqueness: { 
      scope: :namespace_id, 
      message: 'should be unique to your namespace'
    }
  validates :name, 
    exclusion: { 
      in: %w(discussions vocabularies people search repositories applications lists bibliography bibliographies data),
      message: "%{value} is reserved."
    }

  def name_tree
    [owner.name, name]
  end

  def collaborators
    collabs = []
    collabs << accessors
    collabs << invited_collaborators
    return collabs.compact.flatten.uniq
  end

  def permissions
    #Person, can_create, can_read, can_update, can_destroy, can_manage, is_owner 
    permissions = owner.permissions
    collabs = invited_collaborations.map{ |c| Permission.new(person: c.collaborator, can_create: c.can_create, can_read: c.can_read, can_update: c.can_update, can_destroy: c.can_destroy, can_manage: c.can_manage, is_owner: false) }
    permissions << collabs
    return permissions.compact.flatten.uniq
  end

end