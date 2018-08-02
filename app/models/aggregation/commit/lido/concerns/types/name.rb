# Title: Appellation Value
# General: Appellations, e.g. titles, identifying phrases, or names given to an item, but also name of a person or 
# corporation, also place name etc.
# How to record: Repeat this element only for language variants.

class Aggregation::Commit::Lido::Concerns::Types::Name
  include AttrJson::Model
  attr_json :value, :string
  attr_json :label, :string
  attr_json :lang, :string
  attr_json :pref, :string # preferred, alternate
end