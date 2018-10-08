module Chronoi
  class Property::IsEqualInTimeTo < Property
    INVERSE_NAME = 'is equal in time to'

    belongs_to :entity, optional: true
    alias_method :r_entity, :rangeable

    # P114 is equal in time to
    # Domain: E2 Temporal Entity
    # Range: E2 Temporal Entity
    # Quantification: many to many (0,n:0,n) 
    # Definition of the CIDOC Conceptual Reference Model 67
    # Scope note: This symmetric property allows the instances of E2 Temporal Entity with the same E52 TimeSpan to be equated.
    # This property is only necessary if the time span is unknown (otherwise the equivalence can be calculated).
    # This property is the same as the "equal" relationship of Allen’s temporal logic (Allen, 1983, pp. 832-843).
    # Examples:
    #  the destruction of the Villa Justinian Tempus (E6) is equal in time to the death of Maximus Venderus (E69) 
  end
end