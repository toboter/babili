module Chronoi
  class BeginningOfExistence::Creation < BeginningOfExistence
    has_many :has_created, class_name: 'Property::HasCreated', foreign_key: :entity_id

    # E65 Creation
    # Subclass of: E7 Activity
    # E63 Beginning of Existence
    # Superclass of: E83 Type Creation
    # Scope note: This class comprises events that result in the creation of conceptual items or immaterial
    # products, such as legends, poems, texts, music, images, movies, laws, types etc.
    # Examples:
    #  the framing of the U.S. Constitution
    #  the drafting of U.N. resolution 1441
    # Properties:
    # P94 has created (was created by): E28 Conceptual Object 
  end
end