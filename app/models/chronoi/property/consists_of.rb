module Chronoi
  class Property::ConsistsOf < Property::WasInfluencedBy
    INVERSE_NAME = 'forms part of'

    belongs_to :period, optional: true
    alias_method :r_period, :rangeable

    # P9 consists of (forms part of)
    # Domain: E4 Period
    # Range: E4 Period
    # Quantification: one to many, (0,n:0,1)
    # Scope note: This property describes the decomposition of an instance of E4 Period into discrete, subsidiary periods.
    # The sub-periods into which the period is decomposed form a logical whole - although the
    # entire picture may not be completely known - and the sub-periods are constitutive of the general period.
    # Examples:
    #  Cretan Bronze Age (E4) consists of Middle Minoan (E4) 
  end
end