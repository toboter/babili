module Chronoi
  class Property::IsSeparatedFrom < Property
    INVERSE_NAME = 'is separated from'

    belongs_to :period, optional: true
    alias_method :r_period, :rangeable

    # P133 is separated from
    # Domain: E4 Period
    # Range: E4 Period
    # Quantification: many to many (0,n:0,n)
    # Scope note: This symmetric property allows instances of E4 Period that do not overlap both temporally and
    # spatially, to be related i,e. they do not share any spatio-temporal extent. 
    # This property does not imply any ordering or sequence between the two periods either spatial or temporal.
    # Examples:
    #  the “Hallstatt” period (E4) is separated from the “La Tène” era (E4) 
  end
end