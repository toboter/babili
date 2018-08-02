# Title: Object Classification Wrapper
# General: Wrapper for data classifying the object / work.
# Includes all classifying information about an object / work, such as: object / work type, style, genre, form, 
# age, sex, and phase, or by how holding organization structures its collection (e.g. fine art, decorative art, 
# prints and drawings, natural science, numismatics, or local history).

class Aggregation::Commit::Lido::Descriptive::Classification::Base
  include AttrJson::Model
  attr_json :work_types, Aggregation::Commit::Lido::Descriptive::Classification::WorkType.to_type, array: true # 1..n
  attr_json :classifications, Aggregation::Commit::Lido::Descriptive::Classification::Classification.to_type, array: true # 0..n
end