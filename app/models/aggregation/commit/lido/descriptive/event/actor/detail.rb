# Title: Actor in Role
# General: Describes an actor with role and (if necessary) attributions in a structured way, consisting of 
# the sub-elements actor, its role, attribution and extent.

class Aggregation::Commit::Lido::Descriptive::Event::Actor::Detail
  include AttrJson::Model

  attr_json :actor, Aggregation::Commit::Lido::Concerns::Actor::Base.to_type # 0..1
  attr_json :role, Aggregation::Commit::Lido::Descriptive::Event::Actor::Role.to_type, array: true # 0..n
  # Example values: attributed to, studio of, workshop of, atelier of, office of, assistant of, associate of, pupil of, 
  # follower of, school of, circle of, style of, after copyist of, manner of...
  attr_json :attribution, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n
  # Example values: design, execution, with additions by, figures, renovation by, predella, embroidery, cast by, printed by, ...
  attr_json :extent, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n

end