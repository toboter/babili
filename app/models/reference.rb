# Eine reference bindet an ein referencing object. Es kann sich um ein Vocab::Concept, Zensus::Agent, 
# Biblio::Entry, Disscussion::Thread, Aggregation::Identifier, Locate::Place handeln.

# referencing_id:integer
# referencing_type:string
# referenceabel_id:integer
# referenceable_type:string
# referencor_id:integer

class Reference < ApplicationRecord
  belongs_to :referencing, polymorphic: true # from
  belongs_to :referenceable, polymorphic: true # to
  belongs_to :referencor, class_name: 'Person'
  
end