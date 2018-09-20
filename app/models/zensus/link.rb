module Zensus
  class Link < ApplicationRecord
    # t.integer   :agent_id
    # t.string    :uri
    # t.string    :type

    self.inheritance_column = :_type_disabled
    belongs_to :agent

    validates :uri, :type, presence: true

    def self.types
      %w[DataRepresentation PublicationOn]
    end
  end
end