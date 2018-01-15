# t.integer   :appellation_id
# t.integer   :position
# t.string    :body
# t.string    :type
# t.boolean   :preferred

class Zensus::AppellationParts < ApplicationRecord
  self.inheritance_column = :_type_disabled
  acts_as_list
  belongs_to :appellation

  def self.types
    %w[Descriptor Familienname Geburtsname Vorname Rufname]
  end
end