# Title: Event Materials/Technique
# General: Indicates the substances or materials used within the event (e.g. the creation of an object / work), 
# as well as any implements, production or manufacturing techniques, processes, or methods incorporated.
# How to record: Will be used most often within a production event, but also others such as excavation, restoration, etc.

class Aggregation::Commit::Lido::Descriptive::Event::MaterialTechnique::Base
  include JsonAttribute::Model
  json_attribute :sortorder, :integer
  json_attribute :display, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n, uniq: {scope: :lang}
  json_attribute :detail, Aggregation::Commit::Lido::Descriptive::Event::MaterialTechnique::Detail.to_type # 0..1
end