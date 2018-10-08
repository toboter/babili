module Chronoi
  class Property::OccuredInThePresenceOf < Property
    INVERSE_NAME = 'was present at'

    belongs_to :event, optional: true
    alias_method :persistent_item, :rangeable

    # P12 occurred in the presence of (was present at)
    # Domain: E5 Event
    # Range: E77 Persistent Item
    # Superproperty of: E5 Event. P11 had participant (participated in): E39 Actor
    # E7 Activity. P16 used specific object (was used for): E70 Thing
    # E9 Move. P25 moved (moved by): E19 Physical Object
    # E11 Modification. P31 has modified (was modified by): E24 Physical Man-Made Thing
    # E63 Beginning of Existence. P92 brought into existence (was brought into existence by): E77
    # Persistent Item
    # E64 End of Existence. P93 took out of existence (was taken out of existence by): E77
    # Persistent Item
    # E79 Part Addition.P111 added (was added by): E18 Physical Thing
    # E80 Part Removal.P113 removed (was removed by): E18 Physical Thing
    # Quantification: many to many, necessary (1,n:0,n)
    # Scope note: This property describes the active or passive presence of an E77 Persistent Item in an E5 Event without implying any specific role. 
  end
end