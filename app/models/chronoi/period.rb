module Chronoi
  class Period < Entity
   
    has_many :took_place_at, class_name: 'Property::TookPlaceAt', foreign_key: :entity_id
    has_many :took_place_on_or_within, class_name: 'Property::TookPlaceOnOrWithin', foreign_key: :entity_id
    has_many :consists_of_chronoi_periods, class_name: 'Property::ConsistsOf', foreign_key: :entity_id
    has_many :falls_within_chronoi_periods, class_name: 'Property::FallsWithin', foreign_key: :entity_id
    has_many :overlaps_with_chronoi_periods, class_name: 'Property::OverlapsWith', foreign_key: :entity_id
    has_many :separated_from_chronoi_periods, class_name: 'Property::IsSeparatedFrom', foreign_key: :entity_id

    # E4 Period
    # Subclass of: E2 Temporal Entity
    # Superclass of: E5 Event
    # Scope note: This class comprises sets of coherent phenomena or cultural manifestations bounded in time
    # and space.
    # It is the social or physical coherence of these phenomena that identify an E4 Period and not the
    # associated spatio-temporal bounds. These bounds are a mere approximation of the actual
    # process of growth, spread and retreat. Consequently, different periods can overlap and coexist
    # in time and space, such as when a nomadic culture exists in the same area as a sedentary
    # culture.
    # Typically this class is used to describe prehistoric or historic periods such as the “Neolithic
    # Period”, the “Ming Dynasty” or the “McCarthy Era”. There are however no assumptions about
    # the scale of the associated phenomena. In particular all events are seen as synthetic processes
    # consisting of coherent phenomena. Therefore E4 Period is a superclass of E5 Event. For
    # example, a modern clinical E67 Birth can be seen as both an atomic E5 Event and as an E4
    # Period that consists of multiple activities performed by multiple instances of E39 Actor.
    # There are two different conceptualisations of ‘artistic style’, defined either by physical features
    # or by historical context. For example, “Impressionism” can be viewed as a period lasting from
    # approximately 1870 to 1905 during which paintings with particular characteristics were
    # produced by a group of artists that included (among others) Monet, Renoir, Pissarro, Sisley
    # and Degas. Alternatively, it can be regarded as a style applicable to all paintings sharing the
    # characteristics of the works produced by the Impressionist painters, regardless of historical
    # context. The first interpretation is an E4 Period, and the second defines morphological object
    # types that fall under E55 Type.
    # Another specific case of an E4 Period is the set of activities and phenomena associated with a
    # settlement, such as the populated period of Nineveh.
    # Examples:
    #  Jurassic
    #  European Bronze Age
    #  Italian Renaissance
    #  Thirty Years War
    #  Sturm und Drang 
    # Definition of the CIDOC Conceptual Reference Model 4
    #  Cubism
    # Properties:
    # P7 took place at (witnessed): E53 Place
    # P8 took place on or within (witnessed): E19 Physical Object
    # P9 consists of (forms part of): E4 Period
    # P10 falls within (contains): E4 Period
    # P132 overlaps with: E4 Period
    # P133 is separated from: E4 Period
  end
end