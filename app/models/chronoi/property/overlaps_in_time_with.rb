module Chronoi
  class Property::OverlapsInTimeWith < Property
    INVERSE_NAME = 'is overlapped in time by'

    belongs_to :entity, optional: true
    alias_method :r_entity, :rangeable

    # P118 overlaps in time with (is overlapped in time by)
    # Domain: E2 Temporal Entity 
    # Range: E2 Temporal Entity
    # Quantification: many to many (0,n:0,n)
    # Scope note: This property identifies an overlap between the instances of E52 Time-Span of two instances
    # of E2 Temporal Entity.
    # It implies a temporal order between the two entities: if A overlaps in time B, then A must start before B, and B must end after A. This 
    # property is only necessary if the relevant time spans are unknown (otherwise the relationship can be calculated).
    # This property is the same as the "overlaps / overlapped-by" relationships of Allen’s temporal logic (Allen, 1983, pp. 832-843).
    # Examples:
    #  the Iron Age (E4) overlaps in time with the Roman period (E4) 
  end
end