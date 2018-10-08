module Chronoi
  class Property::FromFather < Property
    INVERSE_NAME = 'was father for'

    belongs_to :birth, optional: true
    alias_method :person, :rangeable

    # P97 from father (was father for)
    # Domain: E67 Birth
    # Range: E21 Person
    # Quantification: many to many, necessary (1,n:0,n)
    # Scope note: This property links an E67 Birth event to an E21 Person in the role of biological father.
  end
end