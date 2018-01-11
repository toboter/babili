# t.integer   :id
# t.integer   :concept_id
# t.integer   :creator_id
# t.string    :type
# t.string    :vernacular
# t.string    :historical
# t.string    :body
# t.string    :language
# t.boolean   :is_abbrevation

class Vocab::Label < ApplicationRecord
  self.inheritance_column = :_type_disabled
  belongs_to :concept, class_name: 'Vocab::Concept'
  belongs_to :creator

  validates :body, :language, :type, :vernacular, :historical, presence: true
  validates :body, uniqueness: { scope: [:language, :concept_id], 
    message: "should only exist once per concept and language" }

    def self.types
    %w(Preferred Alternative Hidden)
  end

  def self.vernaculars
    %w(Vernacular Other Undetermined)
  end

  def self.historicals
    %w(Current Historical Both Unknown NotApplicable)
  end

end