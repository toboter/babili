module Chronoi
  class Property::FallsWithin < Property
    INVERSE_NAME = 'contains'

    belongs_to :period, optional: true
    alias_method :r_period, :rangeable

    # P10 falls within (contains)
    # Domain: E4 Period
    # Range: E4 Period
    # Quantification: many to many (0,n:0,n)
    # Scope note: This property describes an instance of E4 Period, which falls within the E53 Place and E52 Time-Span of another.
    # The difference with P9 consists of (forms part of) is subtle. Unlike P9 consists of (forms part
    # of), P10 falls within (contains) does not imply any logical connection between the two periods
    # and it may refer to a period of a completely different type. 
    # Examples:
    #  the Great Plague (E4) falls within The Gothic period (E4)
  end
end