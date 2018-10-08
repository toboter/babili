module Chronoi
  class Property::TookPlaceAt < Property
    INVERSE_NAME = 'witnessed'

    belongs_to :period, optional: true
    alias_method :place, :rangeable

    # P7 took place at (witnessed)
    # Domain: E4 Period
    # Range: E53 Place
    # Superproperty of: E9 Move. P26 moved to (was destination of): E53 Place
    # E9 Move. P27 moved from (was origin of): E53 Place
    # Quantification: many to many, necessary (1,n:0,n)
    # Scope note: This property describes the spatial location of an instance of E4 Period.
    # The related E53 Place should be seen as an approximation of the geographical area within
    # which the phenomena that characterise the period in question occurred. P7took place at
    # (witnessed) does not convey any meaning other than spatial positioning (generally on the
    # surface of the earth). For example, the period “Révolution française” can be said to have taken
    # place in “France”, the “Victorian” period, may be said to have taken place in “Britain” and its
    # colonies, as well as other parts of Europe and north America.
    # A period can take place at multiple locations.
    # Examples:
    #  the period “Révolution française” (E4) took place at France (E53) 
  end
end

