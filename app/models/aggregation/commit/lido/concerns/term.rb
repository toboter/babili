# Title: Term / Label
# General: A name for the referred concept, used for indexing.

class Aggregation::Commit::Lido::Concerns::Term
  include JsonAttribute::Model
  json_attribute :value, :string
  json_attribute :label, :string
  json_attribute :lang, :string
  json_attribute :pref, :string # preferred, alternate
  json_attribute :added_search_term, :string
end