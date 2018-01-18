# t.integer   :agent_id
# t.string    :uri
# t.string    :type

class Zensus::Link < ApplicationRecord
  self.inheritance_column = :_type_disabled
  belongs_to :agent

  def self.types
    %w[NormdateiID ImageURL URIRepresentation]
  end
end