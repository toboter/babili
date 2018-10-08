module Chronoi
  class Property::SeparatedFrom < Property::HadParticipant
    INVERSE_NAME = 'lost member by'

    belongs_to :leaving, optional: true
    alias_method :group, :rangeable

    # P146 separated from (lost member by)
    # Domain: E86 Leaving
    # Range: E74 Group
    # Subproperty of: E5 Event. P11 had participant (participated in): E39 Actor
    # Quantification: many to many, necessary (1,n:0,n)
    # Scope note: This property identifies the instance of E74 Group an instance of E39 Actor leaves through an instance of E86 Leaving.
  end
end