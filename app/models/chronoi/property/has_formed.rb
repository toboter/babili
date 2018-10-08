module Chronoi
  class Property::HasFormed < Property::BroughtIntoExistence
    INVERSE_NAME = 'was formed by'

    belongs_to :formation, optional: true
    alias_method :group, :rangeable

    # P95 has formed (was formed by)
    # Domain: E66 Formation
    # Range: E74 Group
    # Subproperty of: E63 Beginning of Existence. P92 brought into existence (was brought into existence by): E77
    # Persistent Item
    # Quantification: one to many, necessary, dependent (1,n:1,1)
    # Scope note: This property links the founding or E66 Formation for an E74 Group with the Group itself. 
  end
end