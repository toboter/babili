module Chronoi
  class Activity::Joining < Activity
    has_many :joined_with, class_name: 'Property::JoinedWith', foreign_key: :entity_id
    has_many :groups, through: :joined_with, source: :rangeable, source_type: 'Zensus::Agent'
    has_one  :kind_of_member, class_name: 'Property::KindOfMember', foreign_key: :entity_id
    has_many :joined, class_name: 'Property::Joined', foreign_key: :entity_id
    has_many :joiners, through: :joined, source: :rangeable, source_type: 'Zensus::Agent'

    # E85 Joining
    # Subclass of: E7 Activity
    # Scope note: This class comprises the activities that result in an instance of E39 Actor becoming a member
    # of an instance of E74 Group. This class does not imply initiative by either party.
    # Typical scenarios include becoming a member of a social organisation, becoming employee of
    # a company, marriage, the adoption of a child by a family and the inauguration of somebody
    # into an official position.
    # Examples:
    #  The election of Sir Isaac Newton as Member of Parliament for the University of
    # Cambridge to the Convention Parliament of 1689
    #  The inauguration of Mikhail Sergeyevich Gorbachev as leader of the Union of Soviet
    # Socialist Republics (USSR) in 1985
    #  The implementation of the membership treaty between EU and Denmark January 1. 1973
    # Properties:
    # P143 joined (was joined by): E39 Actor
    # P144 joined with (gained member by) E74 Group
    #   (P144.1 kind of member: E55 Type)
  end
end