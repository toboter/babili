# Title: Scale Measurements
# General: An expression of the ratio between the size of the representation of something and that thing (e.g., the size 
# of the drawn structure and the actual built work).
# How to record: Example values for scale: numeric (e.g., 1 inch = 1 foot), full-size, life-size, half size,monumental. 
# and others as recommended in CCO and CDWA. Combine this tag with Measurement Sets for numeric scales. For 
# measurementsSet type for Scale, use "base" for the left side of the equation, and "target" for the right side of
# the equation). Notes Used for studies, record drawings, models, and other representations drawn or constructed to scale.

class Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Scale
  include AttrJson::Model
  attr_json :sortorder, :integer
  attr_json :value, :string
end