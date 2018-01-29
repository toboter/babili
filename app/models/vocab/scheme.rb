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

  def self.sorted_by(sort_option)
    direction = ((sort_option =~ /desc$/) ? 'desc' : 'asc').to_sym
    case sort_option.to_s
    when /^updated_at_/
      { updated_at: direction }
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  end

  def self.options_for_sorted_by
    [
      ['Updated asc', 'updated_at_asc'],
      ['Updated desc', 'updated_at_desc']
    ]
  end
end