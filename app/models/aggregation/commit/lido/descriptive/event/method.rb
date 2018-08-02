# Title: Event Method
# General: The method by which the event is carried out.
# How to record:  Preferably taken from a published controlled vocabulary. Notes Used e.g. for SPECTRUM Units 
# of Information "field collection method", "acquisition method"

class Aggregation::Commit::Lido::Descriptive::Event::Method
  include AttrJson::Model
  attr_json :sortorder, :integer
  attr_json :concept, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  attr_json :term, Aggregation::Commit::Lido::Concerns::Types::Term.to_type, array: true # 0..n
end