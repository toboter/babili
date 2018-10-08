module Chronoi
  class Property::Finishes < Property
    INVERSE_NAME = 'is finished by'

    belongs_to :entity, optional: true
    alias_method :r_entity, :rangeable

    # P115 finishes (is finished by)
    # Domain: E2 Temporal Entity
    # Range: E2 Temporal Entity
    # Quantification: many to many (0,n:0,n)
    # Scope note: This property allows the ending point for a E2 Temporal Entity to be situated by reference to
    # the ending point of another temporal entity of longer duration.
    # This property is only necessary if the time span is unknown (otherwise the relationship can be calculated). This property is the same 
    # as the "finishes / finished-by" relationships of Allen’s temporal logic (Allen, 1983, pp. 832-843).
    # Examples:
    #  Late Bronze Age (E4) finishes Bronze Age (E4) 
  end
end