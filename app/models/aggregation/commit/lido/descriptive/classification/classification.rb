# Title: Classification
# General: Concepts used to categorize an object / work by grouping it together with others on the basis of 
# similar characteristics.
# How to record: The category belongs to a systematic scheme (classification) which groups objects of similar 
# characteristics according to uniform aspects. This grouping / classification may be done according to material, 
# form, shape, function, region of origin, cultural context, or historical or stylistic period. In addition to this
# systematic grouping it may also be done according to organizational divisions within a museum (e.g., according to 
# the collection structure of a museum). If the object / work is assigned to multiple classifications, 
# repeat this element. Preferably taken from a published controlled vocabulary.

class Aggregation::Commit::Lido::Descriptive::Classification::Classification
  include JsonAttribute::Model
  json_attribute :type, :string
  json_attribute :sortorder, :integer
  json_attribute :concept, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  json_attribute :term, Aggregation::Commit::Lido::Concerns::Types::Term.to_type, array: true # 0..n
end