# Title: Place Classification
# General:  A classification of the place, e.g. by geological complex, stratigraphic unit or habitat type

class Aggregation::Commit::Lido::Concerns::Place::Classification
  include AttrJson::Model
  attr_json :type, :string
  attr_json :concept, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  attr_json :term, Aggregation::Commit::Lido::Concerns::Types::Term.to_type, array: true # 0..n

end