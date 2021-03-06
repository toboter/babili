# Title: Administrative Metadata
# General: Holds the administrative metadata for an object / work record.
# How to record: The attribute xml:lang is mandatory and specifies the language of the administrative metadata.
# For fully multi-lingual resources, repeat this element once for each language represented. If only a few data 
# fields (e.g. title, creditline) are provided in more than one language, the respective text elements may be repeated
# specifying the lang attribute on the text level.

class Aggregation::Commit::Lido::Administrative::Base
  include AttrJson::Model
  attr_json :lang, :string
  attr_json :rights, Aggregation::Commit::Lido::Administrative::Right.to_type, array: true
  attr_json :record, Aggregation::Commit::Lido::Administrative::Record.to_type # 1
  attr_json :resources, Aggregation::Commit::Lido::Administrative::Resource.to_type, array: true
end