# t.integer    :event_id
# t.string     :property
# t.references :actable
# t.text       :note
# t.string     :note_type

class Zensus::Activity < ApplicationRecord
  belongs_to :actable, polymorphic: true
  belongs_to :event

  def self.properties
    # EventScope, Property, ActableScope
    [
      {id: 1, event_scopes: Zensus::Event.types, property: ['had participant', 'participated in'], actable_scopes: ['Zensus::Actor']},
      {id: 2, event_scopes: Zensus::Event.types, property: ['occurred in the presence of', 'was present at'], actable_scopes: ['Zensus::Actor', 'Aggregation']},
      {id: 3, event_scopes: Zensus::Event.types-['Birth'], property: ['carried out by', 'performed'], actable_scopes: ['Zensus::Actor']},
      {id: 4, event_scopes: Zensus::Event.types, property: ['was influenced by', 'influenced'], actable_scopes: []},
      {id: 5, event_scopes: Zensus::Event.types, property: ['was motivated by', 'motivated'], actable_scopes: []},
      {id: 6, event_scopes: Zensus::Event.types, property: ['had specific purpose', 'was purpose of'], actable_scopes: ['Zensus::Event']},
      {id: 7, event_scopes: ['Acquisition'], property: ['transferred title to', 'acquired title through'], actable_scopes: ['Zensus::Actor']},
      {id: 8, event_scopes: ['Acquisition'], property: ['transferred title from', 'surrendered title through'], actable_scopes: ['Zensus::Actor']},
      {id: 9, event_scopes: ['Acquisition'], property: ['transferred title of', 'changed ownership through'], actable_scopes: ['Aggregation']},
      {id: 10, event_scopes: ['Move'], property: ['moved', 'moved by'], actable_scopes: ['Zensus::Person']},
      {id: 11, event_scopes: ['Move'], property: ['moved to', 'was destination of'], actable_scopes: ['Vocab::Concept']},
      {id: 12, event_scopes: ['Move'], property: ['moved from', 'was origin of'], actable_scopes: ['Vocab::Concept']},
      {id: 13, event_scopes: ['Transfer of Custody'], property: ['custody surrendered by', 'surrendered custody through'], actable_scopes: ['Zensus::Actor']},
      {id: 14, event_scopes: ['Transfer of Custody'], property: ['custody received by', 'received custody through'], actable_scopes: ['Zensus::Actor']},
      {id: 15, event_scopes: ['Transfer of Custody'], property: ['transferred custody of', 'custody transferred through'], actable_scopes: ['Aggregation']},
      {id: 16, event_scopes: ['Joining'], property: ['joined', 'was joined by'], actable_scopes: ['Zensus::Actor']},
      {id: 17, event_scopes: ['Joining'], property: ['joined with', 'gained member by'], actable_scopes: ['Zensus::Group']},
      {id: 18, event_scopes: ['Leaving'], property: ['separated', 'left by'], actable_scopes: ['Zensus::Actor']},
      {id: 19, event_scopes: ['Leaving'], property: ['separated from', 'lost member by'], actable_scopes: ['Zensus::Group']},
      {id: 20, event_scopes: ['Beginning of Existence'], property: ['brought into existence', 'was brought into existence by'], actable_scopes: ['Zensus::Actor', 'Aggregation']},
      {id: 21, event_scopes: ['Formation'], property: ['has formed', 'was formed by'], actable_scopes: ['Zensus::Group']},
      {id: 22, event_scopes: ['Formation'], property: ['was formed from', 'was formed from'], actable_scopes: ['Zensus::Group']},
      {id: 23, event_scopes: ['Birth'], property: ['by mother', 'gave birth'], actable_scopes: ['Zensus::Person']},
      {id: 24, event_scopes: ['Birth'], property: ['from father', 'was father for'], actable_scopes: ['Zensus::Person']},
      {id: 25, event_scopes: ['Birth'], property: ['brought into life', 'was born'], actable_scopes: ['Zensus::Person']},
      {id: 26, event_scopes: ['Transformation'], property: ['resulted in', 'resulted from'], actable_scopes: ['Zensus::Actor', 'Aggregation']},
      {id: 27, event_scopes: ['Transformation'], property: ['transformed', 'was transformed by'], actable_scopes: ['Zensus::Actor', 'Aggregation']},
      {id: 28, event_scopes: ['End of Existence'], property: ['took out of existence', 'was taken out of existence by'], actable_scopes: ['Zensus::Actor', 'Aggregation']},
      {id: 29, event_scopes: ['Dissolution'], property: ['dissolved', 'was dissolved by'], actable_scopes: ['Zensus::Group']},
      {id: 30, event_scopes: ['Death'], property: ['was death of', 'died in'], actable_scopes: ['Zensus::Person']},
    ]
  end

  def self.note_types
    # Scope, property -> note
    [
      {scope: 'Activity', property: 'in the role of'},
      {scope: 'Joining', property: 'kind of member'}
    ]
  end

  def event_to_actable
    Zensus::Activity.properties.select {|p| p[:id] == property.to_i  }.first[:property].first
  end

  def actable_to_event
    Zensus::Activity.properties.select {|p| p[:id] == property.to_i  }.first[:property].last
  end

  def actable_gid
    actable.try(:to_global_id)
  end

  def actable_gid=(gid)
    self.actable = GlobalID::Locator.locate gid
  end


end