module Chronoi
  class Activity::Leaving < Activity
    has_many :separated_from, class_name: 'Property::SeparatedFrom', foreign_key: :entity_id
    has_many :groups, through: :separated_from, source: :rangeable, source_type: 'Zensus::Agent'
    has_many :separated, class_name: 'Property::Separated', foreign_key: :entity_id
    has_many :separators, through: :separated, source: :rangeable, source_type: 'Zensus::Agent'

    # E86 Leaving
    # Subclass of: E7 Activity
    # Scope note: This class comprises the activities that result in an instance of E39 Actor to be disassociated 
    # Definition of the CIDOC Conceptual Reference Model 34
    # from an instance of E74 Group. This class does not imply initiative by either party.
    # Typical scenarios include the termination of membership in a social organisation, ending the
    # employment at a company, divorce, and the end of tenure of somebody in an official position.
    # Examples:
    #  The end of Sir Isaac Newton’s duty as Member of Parliament for the University of
    # Cambridge to the Convention Parliament in 1702
    #  George Washington’s leaving office in 1797
    #  The implementation of the treaty regulating the termination of Greenland’s membership in
    # EU between EU, Denmark and Greenland February 1. 1985
    # Properties:
    # P145 separated (left by) E39 Actor
    # P146 separated from (lost member by) E74 Group 
  end
end