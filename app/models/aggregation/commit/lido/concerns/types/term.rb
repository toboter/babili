# Title: Term / Label
# General: A name for the referred concept, used for indexing.

class Aggregation::Commit::Lido::Concerns::Types::Term
  include AttrJson::Model
  attr_json :value, :string
  attr_json :label, :string
  attr_json :lang, :string
  attr_json :pref, :string # preferred, alternate
  attr_json :added_search_term, :string
end