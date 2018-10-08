module Chronoi
  class Property::OccursBefore < Property
    INVERSE_NAME = 'occurs after'

    belongs_to :entity, optional: true
    alias_method :r_entity, :rangeable

    # P120 occurs before (occurs after)
    # Domain: E2 Temporal Entity
    # Range: E2 Temporal Entity
    # Quantification: many to many (0,n:0,n)
    # Scope note: This property identifies the relative chronological sequence of two temporal entities.
    # It implies that a temporal gap exists between the end of A and the start of B. This property is
    # only necessary if the relevant time spans are unknown (otherwise the relationship can be calculated).
    # This property is the same as the "before / after" relationships of Allen’s temporal logic (Allen, 1983, pp. 832-843).
    # Examples:
    #  Early Bronze Age (E4) occurs before Late Bronze age (E4) 
  end
end