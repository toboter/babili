module Chronoi
  class BeginningOfExistence::Birth < BeginningOfExistence
    has_one :by_mother, class_name: 'Property::ByMother', foreign_key: :entity_id
    has_one :mother, through: :by_mother, source: :rangeable, source_type: 'Zensus::Agent'
    has_one :from_father, class_name: 'Property::FromFather', foreign_key: :entity_id
    has_one :father, through: :from_father, source: :rangeable, source_type: 'Zensus::Agent'
    has_many :brought_into_life, class_name: 'Property::BroughtIntoLife', foreign_key: :entity_id
    has_many :children, through: :brought_into_life, source: :rangeable, source_type: 'Zensus::Agent'

    accepts_nested_attributes_for :by_mother
    accepts_nested_attributes_for :from_father

    # E67 Birth
    # Subclass of: E63 Beginning of Existence
    # Scope note: This class comprises the births of human beings. E67 Birth is a biological event focussing on
    # the context of people coming into life. (E63 Beginning of Existence comprises the coming into
    # life of any living beings).
    # Twins, triplets etc. are brought into life by the same E67 Birth event. The introduction of the
    # E67 Birth event as a documentation element allows the description of a range of family
    # relationships in a simple model. Suitable extensions may describe more details and the
    # complexity of motherhood with the intervention of modern medicine. In this model, the
    # biological father is not seen as a necessary participant in the E67 Birth event.
    # Properties:
    # P96 by mother (gave birth): E21 Person
    # P97 from father (was father for): E21 Person
    # P98 brought into life (was born): E21 Person 
  end
end