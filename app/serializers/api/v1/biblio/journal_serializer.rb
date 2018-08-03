module Api::V1::Biblio
  class JournalSerializer < Api::V1::Biblio::EntrySerializer
    attribute :name_abbr
    attribute :name
    attribute :abbr

  end
end