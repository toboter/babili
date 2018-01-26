# t.integer   :id
# t.string    :abbr
# t.string    :title
# t.integer   :definer_id
# t.string    :definer_type
# t.integer   :creator_id
# t.string    :slug

class Vocab::Scheme < ApplicationRecord
  extend FriendlyId
  friendly_id :abbr, use: :slugged

  belongs_to :definer, polymorphic: true
  belongs_to :creator, class_name: 'User'
  has_many :concepts, dependent: :destroy

  validates :abbr, presence: true

  def contributors
    [creator].concat(concepts.map{|c| c.contributors}).compact.flatten.uniq
  end

end