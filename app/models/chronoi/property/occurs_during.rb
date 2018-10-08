module Chronoi
  class Property::OccursDuring < Property
    INVERSE_NAME = 'includes'

    belongs_to :entity, optional: true
    alias_method :r_entity, :rangeable

    # P117 occurs during (includes)
    # Domain: E2 Temporal Entity
    # Range: E2 Temporal Entity
    # Quantification: many to many (0,n:0,n)
    # Scope note: This property allows the entire E52 Time-Span of an E2 Temporal Entity to be situated within
    # the Time-Span of another temporal entity that starts before and ends after the included temporal entity.
    # This property is only necessary if the time span is unknown (otherwise the relationship can be calculated). This property is the same 
    # as the "during / includes" relationships of Allen’s temporal logic (Allen, 1983, pp. 832-843).
    # Examples:
    #  Middle Saxon period (E4) occurs during Saxon period (E4) 
  end
end