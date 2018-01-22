# t.integer   :agent_id
# t.string    :uri
# t.string    :type

class Zensus::Link < ApplicationRecord
  self.inheritance_column = :_type_disabled
  belongs_to :agent

  validates :uri, :type, presence: true

  def self.types
    %w[DataRepresentation PublicationOn]
  end
end