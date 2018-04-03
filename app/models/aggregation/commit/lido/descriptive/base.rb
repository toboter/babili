# Title: Descriptive Metadata
# General: Holds the descriptive metadata of an object record.
# How to record: The attribute xml:lang is mandatory and specifies the language of the descriptive metadata.
# For fully multi-lingual resources, repeat this element once for each language represented. If only a few data 
# fields (e.g. title) are provided in more than one language, the respective text elements may be repeated
# specifying the lang attribute on the text level.

class Aggregation::Commit::Lido::Descriptive::Base
  include JsonAttribute::Model
  json_attribute :lang, :string
  json_attribute :classification, Aggregation::Commit::Lido::Descriptive::Classification::Base.to_type # 1
  json_attribute :identification, Aggregation::Commit::Lido::Descriptive::Identification::Base.to_type # 1
  json_attribute :events, Aggregation::Commit::Lido::Descriptive::Event::Base.to_type, array: true # 0..n
  json_attribute :relation, Aggregation::Commit::Lido::Descriptive::Relation::Base.to_type # 0..1
end