module Chronoi
  class Property::Continued < Property::WasInfluencedBy
    INVERSE_NAME = 'was continued by'

    belongs_to :activity, optional: true
    alias_method :r_activity, :rangeable

    # P134 continued (was continued by)
    # Domain: E7 Activity
    # Range: E7 Activity
    # Subproperty of: E7 Activity. P15 was influenced by (influenced): E1 CRM Entity
    # Quantification: many to many (0,n:0,n)
    # Scope note: This property allows two activities t
  end
end