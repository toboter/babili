# t.integer   :subclass_id
# t.string    :subclass_type
# t.string    :name
# t.text      :image_data
# t.text      :about
# t.string    :slug

# t.timestamps

class Agent < ApplicationRecord
  include ImageUploader[:image]
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :subclass, polymorphic: true
  validates :name, presence: true

  scope :people, -> { where(subclass_type: 'Person') } 
  scope :organizations, -> { where(subclass_type: 'Organization') } 

  def should_generate_new_friendly_id?
    name_changed? || super
  end

end