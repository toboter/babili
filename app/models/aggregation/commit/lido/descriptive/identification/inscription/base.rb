# Title: Inscriptions
# General:  A transcription or description of any distinguishing or identifying physical lettering, annotations, 
# texts, markings, or labels that are affixed, applied, stamped, written, inscribed, or attached to the
# object / work, excluding any mark or text inherent in the materials of which it is made. Notes Record watermarks 
# in Display Materials/Techniques.

class Aggregation::Commit::Lido::Descriptive::Identification::Inscription::Base
  include JsonAttribute::Model
  json_attribute :type, :string
  json_attribute :sortorder, :integer
  json_attribute :transcriptions, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n
  json_attribute :descriptions, Aggregation::Commit::Lido::Descriptive::Identification::Inscription::Description.to_type, array: true # 0..n
end