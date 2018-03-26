# Title: Place Classification
# General:  A classification of the place, e.g. by geological complex, stratigraphic unit or habitat type

class Aggregation::Commit::Lido::Concerns::Place::Classification
  include JsonAttribute::Model
  json_attribute :type, :string
  json_attribute :concept, Aggregation::Commit::Lido::Concerns::Concept.to_type, array: true # 0..n
  json_attribute :term, Aggregation::Commit::Lido::Concerns::Term.to_type, array: true # 0..n

end