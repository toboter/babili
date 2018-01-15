# t.integer   :agent_id
# t.string    :language
# t.string    :period
# t.string    :trans

class Zensus::Appellation < ApplicationRecord
  belongs_to :agent
  has_many :appellation_parts

  def self.transis
    %w[Transcription Transliteration]
  end

end

# Appellation
# E35 Title
# E42 Identifier
# E49 Time Appellation (Time-Span)
# E51 Contact Point
# P139 has alternative form: E41 Appellation
# (P139.1 has type: E55 Type)