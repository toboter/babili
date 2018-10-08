module Chronoi
  class Property::JoinedWith < Property::HadParticipant
    INVERSE_NAME = 'gained member by'

    belongs_to :joining, optional: true
    alias_method :group, :rangeable

    # P144 joined with (gained member by)
    # Domain: E85 Joining
    # Range: E74 Group
    # Subproperty of: E5 Event. P11 had participant (participated in): E39 Actor
    # Quantification: many to many, necessary (1,n:0,n)
    # Scope note: This property identifies the instance of E74 Group of which an instance of E39 Actor becomes a member through an instance of E85 Joining.
  end
end