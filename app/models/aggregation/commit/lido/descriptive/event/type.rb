# Title: Event Type
# General: The nature of the event associated with an object / work.
# How to record: Controlled. Recommended: Defined list of subclasses of CRM entity E5 Event.
# Basic event types as recorded in sub-element term include: Acquisition, Collecting, Commisioning, Creation, 
# Designing, Destruction, Event (non-specified), Excavation, Exhibition, Finding, Loss, Modification, Move, 
# Part addition, Part removal, Performance, Planning, Production, Provenance, Publication, Restor

class Aggregation::Commit::Lido::Descriptive::Event::Type
  include JsonAttribute::Model
  json_attribute :concept, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  json_attribute :term, Aggregation::Commit::Lido::Concerns::Types::Term.to_type, array: true # 0..n
end