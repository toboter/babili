module Chronoi
  class Property::Destroyed < Property::TookOutOfExistence
    INVERSE_NAME = 'was destroyed by'

    belongs_to :destruction, optional: true
    alias_method :physical_thing, :rangeable

    # P13 destroyed (was destroyed by)
    # Domain: E6 Destruction
    # Range: E18 Physical Thing
    # Subproperty of: E64 End of Existence. P93 took out of existence (was taken out of existence by): E77
    # Persistent Item
    # Quantification: one to many, necessary (1,n:0,1) 
    # Definition of the CIDOC Conceptual Reference Model 41
    # Scope note: This property allows specific instances of E18 Physical Thing that have been destroyed to be
    # related to a destruction event.
    # Destruction implies the end of an item’s life as a subject of cultural documentation – the
    # physical matter of which the item was composed may in fact continue to exist. A destruction
    # event may be contiguous with a Production that brings into existence a derived object
    # composed partly of matter from the destroyed object.
    # Examples:
    #  the Tay Bridge Disaster (E6) destroyed The Tay Bridge (E22) 
  end
end