module Api::V1::Biblio
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
end