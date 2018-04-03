# Title: Subject Set
# General: Wrapper for display and index elements for one set of subject information.
# How to record: If an object / work has multiple parts or otherwise has separate, multiple subjects, repeat this 
# element and use Extent Subject in the Subject element. This element may also be repeated to distinguish between 
# subjects that reflect what an object / work is *of* (description and identification) from what it is *about*
# (interpretation).

class Aggregation::Commit::Lido::Descriptive::Relation::Subject::Base
  include JsonAttribute::Model

  json_attribute :display, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n, uniq: {scope: :lang}
  json_attribute :detail, Aggregation::Commit::Lido::Descriptive::Relation::Subject::Detail.to_type # 0..1

end