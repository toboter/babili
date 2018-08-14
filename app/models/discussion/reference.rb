# Eien reference bindet an ein comment object. Es kann sich um ein Vocab::Concept, Zensus::Agent, 
# Biblio::Entry, Disscussion::Thread, Aggregation::Identifier, Locate::Place handeln.

# comment_id:integer
# referenceabel_id:integer
# referenceable_type:string

module Discussion
  class Reference < ApplicationRecord
    belongs_to :comment
    belongs_to :referenceable, polymorphic: true
  
  end
end