class Biblio::EntrySerializer <  ActiveModel::Serializer
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include Rails.application.routes.url_helpers
  
  attributes :id, :citation
  attribute :type do
    object.type.demodulize
  end
  attribute :cite do
    object.bibliographic unless object.type.in?(['Biblio::Serie', 'Biblio::Journal'])
  end


end