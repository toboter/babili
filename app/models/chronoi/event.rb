module Chronoi
  class Event < Period

    has_many :had_participant, class_name: 'Property::HadParticipant', foreign_key: :entity_id
    has_many :occured_in_the_presence_of, class_name: 'Property::OccuredInThePresenceOf', foreign_key: :entity_id

    # E5 Event
    # Subclass of: E4 Period
    # Superclass of: E7 Activity
    # E63 Beginning of Existence
    # E64 End of Existence
    # Scope note: This class comprises changes of states in cultural, social or physical systems, regardless of
    # scale, brought about by a series or group of coherent physical, cultural, technological or legal
    # phenomena. Such changes of state will affect instances of E77 Persistent Item or its subclasses.
    # The distinction between an E5 Event and an E4 Period is partly a question of the scale of
    # observation. Viewed at a coarse level of detail, an E5 Event is an ‘instantaneous’ change of
    # state. At a fine level, the E5 Event can be analysed into its component phenomena within a
    # space and time frame, and as such can be seen as an E4 Period. The reverse is not necessarily
    # the case: not all instances of E4 Period give rise to a noteworthy change of state.
    # Examples:
    #  the birth of Cleopatra (E67)
    #  the destruction of Herculaneum by volcanic eruption in 79 AD (E6)
    #  World War II (E7)
    #  the Battle of Stalingrad (E7)
    #  the Yalta Conference (E7)
    #  my birthday celebration 28-6-1995 (E7)
    #  the falling of a tile from my roof last Sunday
    #  the CIDOC Conference 2003 (E7)
    # Properties:
    # P11 had participant (participated in): E39 Actor
    # P12 occurred in the presence of (was present at): E77 Persistent Item 
  end
end