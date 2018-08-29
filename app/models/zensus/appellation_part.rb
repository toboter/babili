# t.integer   :appellation_id
# t.integer   :position
# t.string    :body
# t.string    :type
# t.boolean   :preferred

class Zensus::AppellationPart < ApplicationRecord
  self.inheritance_column = :_type_disabled
  belongs_to :appellation, touch: true, optional: true
  acts_as_list scope: :appellation

  after_commit :reindex_agent
  after_create :set_position

  validates :body, :type, presence: true

  scope :identify, -> name, type { where(body: name, type: type) }

  def set_position
      case type
      when 'Appellation'
        insert_after(['Appellation'])
      when 'Title'
        insert_after(['Appellation', 'Title'])
      when 'Given'
        insert_after(['Appellation', 'Title', 'Given'])
      when 'Particle'
        insert_after(['Appellation', 'Title', 'Given', 'Particle'])
      when 'Family'
        insert_after(['Appellation', 'Title', 'Given', 'Particle', 'Family'])
      when 'Suffix'
        self.move_to_bottom
      else
        raise(ArgumentError, "Invalid appellation type: #{type.inspect}")
      end
  end

  def insert_after(types)
    path = appellation.appellation_parts.where('id NOT IN (?) AND type IN (?)', id, types)
    if path.any?
      self.insert_at((path).last.try(:position).to_i + 1)
    else
      self.insert_at(1)
    end
  end

  def self.types
    %w[Appellation Title Given Nick Family Suffix]
  end

  def reindex_agent
    appellation.agent.reindex if appellation.agent
  end
end