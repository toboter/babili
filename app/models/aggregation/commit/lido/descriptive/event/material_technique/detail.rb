# Title: Materials Technique
# General: Materials and techniques data used for indexing.

class Aggregation::Commit::Lido::Descriptive::Event::MaterialTechnique::Detail
  include AttrJson::Model

  attr_json :terms, Aggregation::Commit::Lido::Descriptive::Event::MaterialTechnique::Term.to_type, array: true # 0..n
  attr_json :extents, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n
  attr_json :sources, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n
end