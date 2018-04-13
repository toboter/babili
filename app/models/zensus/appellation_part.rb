# t.integer   :appellation_id
# t.integer   :position
# t.string    :body
# t.string    :type
# t.boolean   :preferred

class Zensus::AppellationPart < ApplicationRecord
  self.inheritance_column = :_type_disabled
  belongs_to :appellation, touch: true
  acts_as_list scope: :appellation

  after_commit :reindex_agent
  after_create :set_position

  validates :body, :type, presence: true

  def set_position
      case type
      when 'Descriptor'
        self.insert_at(1)
      when 'Prefix'
        insert_after(['Descriptor', 'Prefix'])
      when 'Forename'
        insert_after(['Descriptor', 'Prefix', 'Forename'])
      when 'Surname'
        insert_after(['Descriptor', 'Prefix', 'Forename', 'Surname'])
      when 'Birthname'
        insert_after(['Descriptor', 'Prefix', 'Forename', 'Surname'])
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
    %w[Descriptor Prefix Forename Nick Surname Birthname Suffix]
  end

  def reindex_agent
    appellation.agent.reindex if appellation.agent
  end
end