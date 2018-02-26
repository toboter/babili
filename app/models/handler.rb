# t.integer   :profile_id
# t.string    :profile_type
# t.string    :name
# t.text      :image_data
# t.text      :about
# t.string    :slug

# t.timestamps

class Handler < ApplicationRecord
  include ImageUploader[:image]
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :extension, polymorphic: true
  validates :name, presence: true
end