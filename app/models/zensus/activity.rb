# => zensus_relations
module Zensus
  class Activity < ApplicationRecord
    # t.integer    :event_id => :domainable
    # t.integer    :property_id
    # t.references :actable => :rangeable
    # t.text       :note
    # t.string     :note_type

    after_commit :reindex_event_and_actable, on: [:create, :update]
    
    belongs_to :actable, polymorphic: true
    belongs_to :event

    def self.properties
      # ids comply to CIDOC-CRM Property Hierarchy
      [
        {id: 12, sub_property_to: nil, domain: 'Zensus::Event', range: '_E77_', name: 'occurredInThePresenceOf', inverse_name: 'wasPresentAt', ditransitive: false },
        {id: 11, sub_property_to: 12, domain: 'Zensus::Event', range: 'Zensus::Agent', name: 'hadParticipant', inverse_name: 'participatedIn', ditransitive: false },
        {id: 14, sub_property_to: 11, domain: 'Zensus::Activity', range: 'Zensus::Agent', name: 'carriedOutBy', inverse_name: 'performed', ditransitive: false },
        {id: 96, sub_property_to: 11, domain: 'Zensus::Birth', range: 'Zensus::Person', name: 'byMother', inverse_name: 'gaveBirth', ditransitive: true },
        {id: 99, sub_property_to: 11, domain: 'Zensus::Dissolution', range: 'Zensus::Group', name: 'dissolved', inverse_name: 'wasDissolvedBy', ditransitive: false },
        {id: 143, sub_property_to: 11, domain: 'Zensus::Joining', range: 'Zensus::Agent', name: 'joined', inverse_name: 'joined', ditransitive: false },
        {id: 144, sub_property_to: 11, domain: 'Zensus::Joining', range: 'Zensus::Group', name: 'joinedWith', inverse_name: 'gainedMember', ditransitive: false },
        {id: 145, sub_property_to: 11, domain: 'Zensus::Leaving', range: 'Zensus::Agent', name: 'separated', inverse_name: 'left', ditransitive: false },
        {id: 146, sub_property_to: 11, domain: 'Zensus::Leaving', range: 'Zensus::Group', name: 'separatedFrom', inverse_name: 'lostMember', ditransitive: false },
        {id: 151, sub_property_to: 11, domain: 'Zensus::Formation', range: 'Zensus::Group', name: 'wasFormedFrom', inverse_name: 'participatedIn', ditransitive: false },
        {id: 201, sub_property_to: 11, domain: 'Zensus::Marriage', range: 'Zensus::Person', name: 'wasBridal', inverse_name: 'bridalIn', ditransitive: true },
        {id: 202, sub_property_to: 11, domain: 'Zensus::Marriage', range: 'Zensus::Person', name: 'wasBride', inverse_name: 'brideIn', ditransitive: true },
        {id: 203, sub_property_to: 12, domain: 'Zensus::Marriage', range: 'Zensus::Person', name: 'wasWitnessedBy', inverse_name: 'witnessed', ditransitive: true },
        {id: 92, sub_property_to: 12, domain: 'Zensus::BeginningOfExistence', range: '_E77_', name: 'broughtIntoExistence', inverse_name: 'wasBroughtIntoExistenceBy' },
        {id: 95, sub_property_to: 92, domain: 'Zensus::Formation', range: 'Zensus::Group', name: 'hasFormed', inverse_name: 'wasFormedBy', ditransitive: false },
        {id: 98, sub_property_to: 92, domain: 'Zensus::Birth', range: 'Zensus::Person', name: 'broughtIntoLive', inverse_name: 'wasBorn', ditransitive: true },
        {id: 93, sub_property_to: 12, domain: 'Zensus::EndOfExistence', range: '_E77_', name: 'tookOutOfExistence', inverse_name: 'wasTakenOutOfExistenceBy' },
        {id: 99, sub_property_to: 93, domain: 'Zensus::Dissolution', range: 'Zensus::Group', name: 'dissolved', inverse_name: 'wasDissolvedBy', ditransitive: false },
        {id: 100, sub_property_to: 93, domain: 'Zensus::Death', range: 'Zensus::Person', name: 'wasDeathOf', inverse_name: 'diedIn', ditransitive: false },
        {id: 15, sub_property_to: nil, domain: 'Zensus::Activity', range: '_E1_', name: 'wasInfluencedBy', inverse_name: 'influenced', ditransitive: false },
        {id: 20, sub_property_to: nil, domain: 'Zensus::Activity', range: 'Zensus::Event', name: 'hadSpecificPurpose', inverse_name: 'wasPurposeOf', ditransitive: false },
        {id: 97, sub_property_to: nil, domain: 'Zensus::Birth', range: 'Zensus::Person', name: 'fromFather', inverse_name: 'wasFatherFor', ditransitive: true },
        #{id: 107, sub_property_to: nil, domain: 'Zensus::Group', range: 'Zensus::Agent', name: 'hasCurrentOrFormerMember', inverse_name: 'isCurrentOrFormerMemberOf' },
        #{id: 152, sub_property_to: nil, domain: 'Zensus::Person', range: 'Zensus::Person', name: 'hasParent', inverse_name: 'isParentOf' },
        {id: 501, sub_property_to: nil, domain: 'Zensus::Survey', range: 'Zensus::Agent', name: 'surveyed', inverse_name: 'surveyed', ditransitive: true },
        {id: 502, sub_property_to: nil, domain: 'Zensus::Excavation', range: 'Zensus::Agent', name: 'excavated', inverse_name: 'excavated', ditransitive: true },
      ]
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
end