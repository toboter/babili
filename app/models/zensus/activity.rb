# => zensus_relations

# t.integer    :event_id => :domainable
# t.integer    :property_id
# t.references :actable => :rangeable
# t.text       :note
# t.string     :note_type

class Zensus::Activity < ApplicationRecord
  after_commit :reindex_event_and_actable, on: [:create, :update]
  
  belongs_to :actable, polymorphic: true
  belongs_to :event

  def self.properties
    # ids comply to CIDOC-CRM Property Hierarchy
    [
      {id: 12, sub_property_to: nil, domain: 'Zensus::Event', range: '_E77_', name: 'occurredInThePresenceOf', inverse_name: 'wasPresentAt' },
      {id: 11, sub_property_to: 12, domain: 'Zensus::Event', range: 'Zensus::Agent', name: 'hadParticipant', inverse_name: 'participatedIn' },
      {id: 14, sub_property_to: 11, domain: 'Zensus::Activity', range: 'Zensus::Agent', name: 'carriedOutBy', inverse_name: 'performed' },
      {id: 96, sub_property_to: 11, domain: 'Zensus::Birth', range: 'Zensus::Person', name: 'byMother', inverse_name: 'gaveBirth' },
      {id: 99, sub_property_to: 11, domain: 'Zensus::Dissolution', range: 'Zensus::Group', name: 'dissolved', inverse_name: 'wasDissolvedBy' },
      {id: 143, sub_property_to: 11, domain: 'Zensus::Joining', range: 'Zensus::Agent', name: 'joined', inverse_name: 'wasJoinedBy' },
      {id: 144, sub_property_to: 11, domain: 'Zensus::Joining', range: 'Zensus::Group', name: 'joinedWith', inverse_name: 'gainedMemberBy' },
      {id: 145, sub_property_to: 11, domain: 'Zensus::Leaving', range: 'Zensus::Agent', name: 'separated', inverse_name: 'leftBy' },
      {id: 146, sub_property_to: 11, domain: 'Zensus::Leaving', range: 'Zensus::Group', name: 'separatedFrom', inverse_name: 'lostMemberBy' },
      {id: 151, sub_property_to: 11, domain: 'Zensus::Formation', range: 'Zensus::Group', name: 'wasFormedFrom', inverse_name: 'participatedIn' },
      {id: 201, sub_property_to: 11, domain: 'Zensus::Marriage', range: 'Zensus::Person', name: 'wasBridal', inverse_name: 'bridalIn' },
      {id: 202, sub_property_to: 11, domain: 'Zensus::Marriage', range: 'Zensus::Person', name: 'wasBride', inverse_name: 'brideIn' },
      {id: 203, sub_property_to: 12, domain: 'Zensus::Marriage', range: 'Zensus::Person', name: 'wasWitnessedBy', inverse_name: 'witnessed' },
      {id: 92, sub_property_to: 12, domain: 'Zensus::BeginningOfExistence', range: '_E77_', name: 'broughtIntoExistence', inverse_name: 'wasBroughtIntoExistenceBy' },
      {id: 95, sub_property_to: 92, domain: 'Zensus::Formation', range: 'Zensus::Group', name: 'hasFormed', inverse_name: 'wasFormedBy' },
      {id: 98, sub_property_to: 92, domain: 'Zensus::Birth', range: 'Zensus::Person', name: 'broughtIntoLive', inverse_name: 'wasBorn' },
      {id: 93, sub_property_to: 12, domain: 'Zensus::EndOfExistence', range: '_E77_', name: 'tookOutOfExistence', inverse_name: 'wasTakenOutOfExistenceBy' },
      {id: 99, sub_property_to: 93, domain: 'Zensus::Dissolution', range: 'Zensus::Group', name: 'dissolved', inverse_name: 'wasDissolvedBy' },
      {id: 100, sub_property_to: 93, domain: 'Zensus::Death', range: 'Zensus::Person', name: 'wasDeathOf', inverse_name: 'diedIn' },
      {id: 15, sub_property_to: nil, domain: 'Zensus::Activity', range: '_E1_', name: 'wasInfluencedBy', inverse_name: 'influenced' },
      {id: 20, sub_property_to: nil, domain: 'Zensus::Activity', range: 'Zensus::Event', name: 'hadSpecificPurpose', inverse_name: 'wasPurposeOf' },
      {id: 97, sub_property_to: nil, domain: 'Zensus::Birth', range: 'Zensus::Person', name: 'fromFather', inverse_name: 'wasFatherFor' },
      #{id: 107, sub_property_to: nil, domain: 'Zensus::Group', range: 'Zensus::Agent', name: 'hasCurrentOrFormerMember', inverse_name: 'isCurrentOrFormerMemberOf' },
      #{id: 152, sub_property_to: nil, domain: 'Zensus::Person', range: 'Zensus::Person', name: 'hasParent', inverse_name: 'isParentOf' },
    ]

    # [
    #   {id: 1,  event_scopes: Zensus::Event.types, property: ['had participant', 'participated in'], actable_scopes: ['Zensus::Actor']},
    #   {id: 2,  event_scopes: Zensus::Event.types, property: ['occurred in the presence of', 'was present at'], actable_scopes: ['Zensus::Actor', 'Aggregation']},
    #   {id: 3,  event_scopes: Zensus::Event.types-['Birth'], property: ['carried out by', 'performed'], actable_scopes: ['Zensus::Actor']},
    #   {id: 4,  event_scopes: Zensus::Event.types, property: ['was influenced by', 'influenced'], actable_scopes: []},
    #   {id: 5,  event_scopes: Zensus::Event.types, property: ['was motivated by', 'motivated'], actable_scopes: []},
    #   {id: 6,  event_scopes: Zensus::Event.types, property: ['had specific purpose', 'was purpose of'], actable_scopes: ['Zensus::Event']},
    #   {id: 7,  event_scopes: ['Acquisition'], property: ['transferred title to', 'acquired title through'], actable_scopes: ['Zensus::Actor']},
    #   {id: 8,  event_scopes: ['Acquisition'], property: ['transferred title from', 'surrendered title through'], actable_scopes: ['Zensus::Actor']},
    #   {id: 9,  event_scopes: ['Acquisition'], property: ['transferred title of', 'changed ownership through'], actable_scopes: ['Aggregation']},
    #   {id: 10, event_scopes: ['Move'], property: ['moved', 'moved by'], actable_scopes: ['Zensus::Person']},
    #   {id: 11, event_scopes: ['Move'], property: ['moved to', 'was destination of'], actable_scopes: ['Vocab::Concept']},
    #   {id: 12, event_scopes: ['Move'], property: ['moved from', 'was origin of'], actable_scopes: ['Vocab::Concept']},
    #   {id: 13, event_scopes: ['Transfer of Custody'], property: ['custody surrendered by', 'surrendered custody through'], actable_scopes: ['Zensus::Actor']},
    #   {id: 14, event_scopes: ['Transfer of Custody'], property: ['custody received by', 'received custody through'], actable_scopes: ['Zensus::Actor']},
    #   {id: 15, event_scopes: ['Transfer of Custody'], property: ['transferred custody of', 'custody transferred through'], actable_scopes: ['Aggregation']},
    #   {id: 16, event_scopes: ['Joining'], property: ['joined by', 'was joined by'], actable_scopes: ['Zensus::Actor']},
    #   {id: 17, event_scopes: ['Joining'], property: ['joined with', 'gained member by'], actable_scopes: ['Zensus::Group']},
    #   {id: 18, event_scopes: ['Leaving'], property: ['left by', 'separated'], actable_scopes: ['Zensus::Actor']},
    #   {id: 19, event_scopes: ['Leaving'], property: ['separated from', 'lost member by'], actable_scopes: ['Zensus::Group']},
    #   {id: 20, event_scopes: ['Beginning of Existence'], property: ['brought into existence', 'was brought into existence by'], actable_scopes: ['Zensus::Actor', 'Aggregation']},
    #   {id: 21, event_scopes: ['Formation'], property: ['has formed', 'was formed by'], actable_scopes: ['Zensus::Group']},
    #   {id: 22, event_scopes: ['Formation'], property: ['was formed from', 'was formed from'], actable_scopes: ['Zensus::Group']},
    #   {id: 23, event_scopes: ['Zensus::Event::Birth'], property: ['by mother', 'is mother for'], actable_scopes: ['Zensus::Person']}, # cardinality: 1
    #   {id: 24, event_scopes: ['Zensus::Event::Birth'], property: ['from father', 'was father for'], actable_scopes: ['Zensus::Person']},
    #   {id: 25, event_scopes: ['Zensus::Event::Birth'], property: ['brought into life', 'was born'], actable_scopes: ['Zensus::Person']},
    #   {id: 26, event_scopes: ['Transformation'], property: ['resulted in', 'resulted from'], actable_scopes: ['Zensus::Actor', 'Aggregation']},
    #   {id: 27, event_scopes: ['Transformation'], property: ['transformed', 'was transformed by'], actable_scopes: ['Zensus::Actor', 'Aggregation']},
    #   {id: 28, event_scopes: ['End of Existence'], property: ['took out of existence', 'was taken out of existence by'], actable_scopes: ['Zensus::Actor', 'Aggregation']},
    #   {id: 29, event_scopes: ['Dissolution'], property: ['dissolved', 'was dissolved by'], actable_scopes: ['Zensus::Group']},
    #   {id: 30, event_scopes: ['Death'], property: ['was death of', 'died in'], actable_scopes: ['Zensus::Person']},
    #   {id: 31, event_scopes: ['GenderAssignment'], property: ['sex assigned to', 'has assigned sex'], actable_scopes: ['Zensus::Person']},
    #   {id: 32, event_scopes: ['GenderAssignment'], property: ['assigned by', 'was assigned by'], actable_scopes: ['Zensus::Person']},
    #   {id: 33, event_scopes: ['GenderAssignment'], property: ['assigned sex is', 'was assigned to'], actable_scopes: ['Vocab::Concept']}
    # ]
  end

  def event_to_actable
    Zensus::Activity.properties.select {|p| p[:id] == property_id  }.first[:name]
  end

  def actable_to_event
    Zensus::Activity.properties.select {|p| p[:id] == property_id  }.first[:inverse_name]
  end

  def title
    "#{actable_to_event} (#{event.type}) on #{event.default_date}"
  end

  def description
    "#{actable.default_name} #{actable_to_event} #{[event.activities-[self]].flatten.map{|a| [a.event_to_actable, a.actable.default_name].join(' ') }.join(', ')}#{' on ' + event.default_date if event.begins_at.present?}"
    #  #{event.type} #{[event.activities-[self]].flatten.map{|a| a.actable.default_name}.join(', ')}
  end

  def actable_gid
    actable.try(:to_global_id)
  end

  def actable_gid=(gid)
    self.actable = GlobalID::Locator.locate gid
  end


  def reindex_event_and_actable
    event.reindex
    actable.reindex
  end
end