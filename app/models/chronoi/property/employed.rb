module Chronoi
  class Property::Employed < Property
    INVERSE_NAME = 'was employed in'

    belongs_to :modification, optional: true
    alias_method :material, :rangeable

    # P126 employed (was employed in)
    # Domain: E11 Modification
    # Range: E57 Material
    # Quantification: many to many (0,n:0,n)
    # Scope note: This property identifies E57 Material employed in an E11 Modification.
    # The E57 Material used during the E11 Modification does not necessarily become incorporated
    # into the E24 Physical Man-Made Thing that forms the subject of the E11 Modification.
    # Examples:
    #  the repairing of the Queen Mary (E11) employed Steel (E57)
    #  distilled water (E57) was employed in the restoration of the Sistine Chapel (E11) 
  end
end