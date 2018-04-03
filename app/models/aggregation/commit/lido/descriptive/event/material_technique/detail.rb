# Title: Materials Technique
# General: Materials and techniques data used for indexing.

class Aggregation::Commit::Lido::Descriptive::Event::MaterialTechnique::Detail
  include JsonAttribute::Model

  json_attribute :terms, Aggregation::Commit::Lido::Descriptive::Event::MaterialTechnique::Term.to_type, array: true # 0..n
  json_attribute :extents, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n
  json_attribute :sources, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n
end