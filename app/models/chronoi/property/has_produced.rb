module Chronoi
  class Property::HasProduced < Property::HasModified
    INVERSE_NAME = 'was produced by'

    belongs_to :production, optional: true
    alias_method :physical_man_made_thing, :rangeable

    # P108 has produced (was produced by)
    # Domain: E12 Production
    # Range: E24 Physical Man-Made Thing
    # Subproperty of: E11 Modification. P31 has modified (was modified by): E24 Physical Man-Made Thing
    # E63 Beginning of Existence. P92 brought into existence (was brought into existence by): E77
    # Persistent Item
    # Quantification: one to many, necessary, dependent (1,n:1,1)
    # Scope note: This property identifies the E24 Physical Man-Made Thing that came into existence as a result
    # of an E12 Production.
    # The identity of an instance of E24 Physical Man-Made Thing is not defined by its matter, but
    # by its existence as a subject of documentation. An E12 Production can result in the creation of
    # multiple instances of E24 Physical Man-Made Thing.
    # Examples:
    #  The building of Rome (E12) has produced Τhe Colosseum (E22) 
  end
end