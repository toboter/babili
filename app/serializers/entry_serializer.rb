class EntrySerializer < ActiveModel::Serializer
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::TextHelper
    include Rails.application.routes.url_helpers
    type :entry
    
    attributes :id, :citation

    attribute :url do
      url_for([:v1, object])
    end

    attribute :html_url do
      url_for(object)
    end

    attribute :type do
      object.type.demodulize
    end

    attribute :cite do
      object.bibliographic unless object.type.in?(['Biblio::Serie', 'Biblio::Journal'])
    end

end

# [
  # {
  # "author": [
  # {
  # "family": "Schmidt",
  # "given": "T."
  # }
  # ],
  # "title": "Files are everywhere.",
  # "editor": [
  # {
  # "family": "Katja Sternitzke",
  # "non-dropping-particle": "and beyondby"
  # },
  # {
  # "family": "May-Sarah Zessin",
  # "given": "Babylon"
  # },
  # {
  # "family": "Wissenschaftliche"
  # }
  # ],
  # "publisher": "sdv Saarländische Druckerei und Verlag",
  # "source": "Veröffentlichungen der Deutschen Orient-Gesellschaft 201",
  # "language": "nl",
  # "publisher-place": "Berlin",
  # "issued": {
  # "date-parts": [
  # [
  # 2019
  # ]
  # ]
  # },
  # "id": "schmidt2019a",
  # "type": "chapter"
  # }
# ]