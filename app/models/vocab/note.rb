# t.integer   :id
# t.integer   :concept_id
# t.integer   :creator_id
# t.string    :type
# t.string    :body
# t.string    :language

class Vocab::Note < ApplicationRecord
  self.inheritance_column = :_type_disabled
  belongs_to :concept
  belongs_to :creator, class_name: 'User'

  validates :type, :body, :language, presence: true

  def self.types
    %w(Scope Definition Example History Editorial Change)
  end

end