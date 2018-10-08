module Chronoi
  class BeginningOfExistence::Formation < BeginningOfExistence
    has_one :has_formed, class_name: 'Property::HasFormed', foreign_key: :entity_id
    has_one :group, through: :has_formed, source: :rangeable, source_type: 'Zensus::Agent'

    # E66 Formation
    # Subclass of: E7 Activity
    # E63 Beginning of Existence
    # Scope note: This class comprises events that result in the formation of a formal or informal E74 Group of
    # people, such as a club, society, association, corporation or nation.
    # E66 Formation does not include the arbitrary aggregation of people who do not act as a collective.
    # The formation of an instance of E74 Group does not mean that the group is populated with
    # members at the time of formation. In order to express the joining of members at the time of
    # formation, the respective activity should be simultaneously an instance of both E66 Formation
    # and E85 Joining.
    # Properties:
    # P95 has formed (was formed by): E74 Group 
  end
end