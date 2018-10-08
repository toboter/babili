module Chronoi
  class Property::Dissolved < Property::HadParticipant
    INVERSE_NAME = 'was dissolved by'

    belongs_to :dissolution, optional: true
    alias_method :group, :rangeable

    # P99 dissolved (was dissolved by)
    # Domain: E68 Dissolution
    # Range: E74 Group
    # Subproperty of: E5 Event. P11 had participant (participated in): E39 Actor
    # E64 End of Existence. P93 took out of existence (was taken out of existence by): E77 Persistent Item
    # Quantification: one to many, necessary (1,n:0,n)
    # Scope note: This property links the disbanding or E68 Dissolution of an E74 Group to the Group itself. 
  end
end