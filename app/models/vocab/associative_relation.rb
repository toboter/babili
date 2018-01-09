# t.integer   :id
# t.integer   :concept_id
# t.string    :property
# t.integer   :related_concept_id
# t.string    :value

class Vocab::AssociativeRelation < ApplicationRecord
  belongs_to :concept, class_name: "Concept"
  belongs_to :related_concept, class_name: "Concept"
  validates :property, :value, presence: true

  attr_accessor :scheme

  def self.properties
    %w(close exact related broader narrower)
  end

end