class Biblio::Referencation < ApplicationRecord
  belongs_to :entry
  belongs_to :repository
  belongs_to :creator, class_name: 'Person'

  validates :entry, uniqueness: { scope: :repository,
    message: "already on the list" }
end