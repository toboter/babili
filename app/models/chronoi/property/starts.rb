module Chronoi
  class Property::Starts < Property
    INVERSE_NAME = 'is started by'

    belongs_to :entity, optional: true
    alias_method :r_entity, :rangeable

    # P116 starts (is started by)
    # Domain: E2 Temporal Entity
    # Range: E2 Temporal Entity
    # Quantification: many to many (0,n:0,n)
    # Scope note: This property allows the starting point for a E2 Temporal Entity to be situated by reference to
    # the starting point of another temporal entity of longer duration.
    # This property is only necessary if the time span is unknown (otherwise the relationship can be calculated). This property is the same 
    # as the "starts / started-by" relationships of Allen’s temporal logic (Allen, 1983, pp. 832-843).
    # Examples:
    #  Early Bronze Age (E4) starts Bronze Age (E4)
  end
end