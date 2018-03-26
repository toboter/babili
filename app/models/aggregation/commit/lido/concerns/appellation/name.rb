# Title: Appellation Value
# General: Appellations, e.g. titles, identifying phrases, or names given to an item, but also name of a person or 
# corporation, also place name etc.
# How to record: Repeat this element only for language variants.

class Aggregation::Commit::Lido::Concerns::Appellation::Name
  include JsonAttribute::Model
  json_attribute :value, :string
  json_attribute :label, :string
  json_attribute :lang, :string
  json_attribute :pref, :string # preferred, alternate
end