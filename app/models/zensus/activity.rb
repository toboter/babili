# t.integer    :event_id
# t.string     :property
# t.references :actable
# t.text       :note
# t.string     :note_type

class Zensus::Activity < ApplicationRecord
  belongs_to :actable, polymorphic: true
  belongs_to :event

  def self.properties
    all = ['Activity', 'Acquisition', 'Move',' Transfer of Custody', 'Joining', 'Leaving', 'Beginning of Existence', 'Formation', 'Birth', 'Transformation', 'End of Existence', 'Dissolution', 'Death']
    # EventScope, Property, ActableScope
    [
      {all, {'had participant', 'participated in'}, ['Actor']},
      {all, {'occurred in the presence of', 'was present at'}, ['Actor', 'Aggregation']},
      {all-['Birth'], {'carried out by', 'performed'}, ['Actor']},
      {all, {'was influenced by', 'influenced'}, []},
      {all, {'was motivated by', 'motivated'}, []},
      {all, {'had specific purpose', 'was purpose of'}, ['Event']},
      {['Acquisition'], {'transferred title to', 'acquired title through'}, ['Actor']},
      {['Acquisition'], {'transferred title from', 'surrendered title through'}, ['Actor']},
      {['Acquisition'], {'transferred title of', 'changed ownership through'}, ['Aggregation']}, # E18 Physical Thing
      {['Move'], {'moved', 'moved by'}, ['Person']}, # E19 Physical Object
      {['Move'], {'moved to', 'was destination of'}, ['Vocab::Concept']},   # E53 Place
      {['Move'], {'moved from', 'was origin of'}, ['Vocab::Concept']},      # E53 Place
      {['Transfer of Custody'], {'custody surrendered by', 'surrendered custody through'}, ['Actor']},
      {['Transfer of Custody'], {'custody received by', 'received custody through'}, ['Actor']},
      {['Transfer of Custody'], {'transferred custody of', 'custody transferred through'}, ['Aggregation']}, # E18 Physical Thing
      {['Joining'], {'joined', 'was joined by'}, ['Actor']},
      {['Joining'], {'joined with', 'gained member by'}, ['Group']},
      {['Leaving'], {'separated', 'left by'}, ['Actor']},
      {['Leaving'], {'separated from', 'lost member by'}, ['Group']},
      {['Beginning of Existence'], {'brought into existence', 'was brought into existence by'}, ['Actor', 'Aggregation']},
      {['Formation'], {'has formed', 'was formed by'}, ['Group']},
      {['Formation'], {'was formed from', 'was formed from'}, ['Group']},
      {['Birth'], {'by mother', 'gave birth'}, ['Person']},
      {['Birth'], {'from father', 'was father for'}, ['Person']},
      {['Birth'], {'brought into life', 'was born'}, ['Person']},
      {['Transformation'], {'resulted in', 'resulted from'}, ['Actor', 'Aggregation']},
      {['Transformation'], {'transformed', 'was transformed by'}, ['Actor', 'Aggregation']},
      {['End of Existence'], {'took out of existence', 'was taken out of existence by'}, ['Actor', 'Aggregation']},
      {['Dissolution'], {'dissolved', 'was dissolved by'}, ['Group']},
      {['Death'], {'was death of', 'died in'}, ['Person']}
    ]
  end

  def self.note_types
    # Scope, property -> note
    [
      {'Activity', 'in the role of'},
      {'Joining', 'kind of member')}
    ]
  end


end