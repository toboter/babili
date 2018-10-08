module Chronoi
  class Property::HasModified < Property::OccuredInThePresenceOf
    INVERSE_NAME = 'was modified by'

    belongs_to :modification, optional: true
    alias_method :physical_man_made_thing, :rangeable

    # P31 has modified (was modified by)
    # Domain: E11 Modification
    # Range: E24 Physical Man-Made Thing
    # Subproperty of: E5 Event. P12 occurred in the presence of (was present at): E77 Persistent Item
    # Superproperty of: E12 Production. P108 has produced (was produced by): E24 Physical Man-Made Thing
    # E79 Part Addition. P110 augmented (was augmented by): E24 Physical Man-Made Thing
    # E80 Part Removal. P112 diminished (was diminished by): E24 Physical Man-Made Thing
    # Quantification: many to many, necessary (1,n:0,n)
    # Scope note: This property identifies the E24 Physical Man-Made Thing modified in an E11 Modification.
    # If a modification is applied to a non-man-made object, it is regarded as an E22 Man-Made
    # Object from that time onwards.
    # Examples:
    #  rebuilding of the Reichstag (E11) has modified the Reichstag in Berlin (E24) 
  end
end