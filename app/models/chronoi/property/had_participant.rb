module Chronoi
  class Property::HadParticipant < Property::OccuredInThePresenceOf
    INVERSE_NAME = 'participated in'

    belongs_to :event, optional: true
    alias_method :agent, :rangeable

    # P11 had participant (participated in)
    # Domain: E5 Event
    # Range: E39 Actor
    # Subproperty of: E5 Event. P12 occurred in the presence of (was present at): E77 Persistent Item
    # Superproperty of: E7 Activity. P14 carried out by (performed): E39 Actor
    # E67 Birth. P96 by mother (gave birth): E21 Person
    # E68 Dissolution. P99 dissolved (was dissolved by): E74 Group
    # E85 Joining.P143 joined (was joined by): E39 Actor
    # E85 Joining.P144 joined with (gained member by): E74 Group
    # E86 Leaving.P145 separated (left by):E39 Actor
    # E86 Leaving.P146 separated from (lost member by):E74 Group
    # Quantification: many to many (0,n:0,n)
    # Scope note: This property describes the active or passive participation of instances of E39 Actors in an E5 Event. 

  end
end