module Chronoi
  class Property::KindOfMember < Property
    INVERSE_NAME = 'kind of member'

    belongs_to :joining, optional: true
    alias_method :concept, :rangeable

    # P144.1 => JoinedWith
  end
end