module Chronoi
  class Property::MeetsInTimeWith < Property
    INVERSE_NAME = 'is met in time by'

    belongs_to :entity, optional: true
    alias_method :r_entity, :rangeable

    # P119 meets in time with (is met in time by)
    # Domain: E2 Temporal Entity
    # Range: E2 Temporal Entity
    # Quantification: many to many (0,n:0,n)
    # Scope note: This property indicates that one E2 Temporal Entity immediately follows another. It implies a particular order between 
    # the two entities: if A meets in time with B, then A must precede B. This property is only necessary if the relevant time spans are unknown 
    # (otherwise the relationship can be calculated).
    # This property is the same as the "meets / met-by" relationships of Allen’s temporal logic (Allen, 1983, pp. 832-843).
    # Examples:
    #  Early Saxon Period (E4) meets in time with Middle Saxon Period (E4) 
  end
end