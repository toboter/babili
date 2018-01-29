class Vocab::NoteSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  type :note

  attributes :type, :body, :language
  

end