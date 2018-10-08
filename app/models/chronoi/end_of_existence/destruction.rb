module Chronoi
  class EndOfExistence::Destruction < EndOfExistence
    has_many :destroyed, class_name: 'Property::Destroyed', foreign_key: :entity_id

    # E6 Destruction
    # Subclass of: E64 End of Existence
    # Scope note: This class comprises events that destroy one or more instances of E18 Physical Thing such that
    # they lose their identity as the subjects of documentation.
    # Some destruction events are intentional, while others are independent of human activity.
    # Intentional destruction may be documented by classifying the event as both an E6 Destruction
    # and E7 Activity.
    # The decision to document an object as destroyed, transformed or modified is context sensitive:
    # 1. If the matter remaining from the destruction is not documented, the event is modelled solely as E6 Destruction.
    # 2. An event should also be documented using E81 Transformation if it results in the
    # destruction of one or more objects and the simultaneous production of others using parts or
    # material from the original. In this case, the new items have separate identities. Matter is
    # preserved, but identity is not.
    # 3. When the initial identity of the changed instance of E18 Physical Thing is preserved, the
    # event should be documented as E11 Modification.
    # Examples:
    #  the destruction of Herculaneum by volcanic eruption in 79 AD
    #  the destruction of Nineveh (E6, E7) 
    # Definition of the CIDOC Conceptual Reference Model 5
    #  the breaking of a champagne glass yesterday by my dog
    # Properties:
    # P13 destroyed (was destroyed by): E18 Physical Thing
  end
end