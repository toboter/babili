class Profile < ApplicationRecord
  include ImageUploader[:image]
  extend FriendlyId
  friendly_id :display_name, use: :slugged

  validates :user, presence: true

  belongs_to :user

  def name
    display_name
  end
  def display_name
    [honorific_prefix, given_name, family_name, honorific_suffix].join(' ').strip
  end

  def should_generate_new_friendly_id?
    changed?
  end

end
