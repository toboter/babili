module Chronoi
  class Property::OverlapsWith < Property
    INVERSE_NAME = 'overlaps with'

    belongs_to :period, optional: true
    alias_method :r_period, :rangeable

    # P132 overlaps with
    # Domain: E4 Period
    # Range: E4 Period
    # Quantification: many to many (0,n:0,n)
    # Scope note: This symmetric property allows instances of E4 Period that overlap both temporally and
    # spatially to be related, i,e. they share some spatio-temporal extent.
    # This property does not imply any ordering or sequence between the two periods, either spatial or temporal.
    # Examples:
    #  the “Urnfield” period (E4) overlaps with the “Hallstatt” period (E4) 
  end
end