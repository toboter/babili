module Chronoi
  class Property::TookPlaceOnOrWithin < Property
    INVERSE_NAME = 'witnessed'

    belongs_to :period, optional: true
    alias_method :physical_object, :rangeable

    # P8 took place on or within (witnessed)
    # Domain: E4 Period
    # Range: E19 Physical Object
    # Quantification: many to many (0,n:0,n)
    # Scope note: This property describes the location of an instance of E4 Period with respect to an E19 Physical Object.
    # P8 took place on or within (witnessed) is a short-cut of a path defining a E53 Place with
    # respect to the geometry of an object. cf. E46 Section Definition.
    # This property is in effect a special case of P7 took place at. It describes a period that can be
    # located with respect to the space defined by an E19 Physical Object such as a ship or a
    # building. The precise geographical location of the object during the period in question may be unknown or unimportant.
    # For example, the French and German armistice of 22 June 1940 was signed in the same railway carriage as the armistice of 11 November 1918.
    # Examples:
    #  the coronation of Queen Elizabeth II (E7) took place on or within Westminster Abbey (E19) 
  end
end