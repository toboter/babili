class Biblio::EntrySerializer <  ActiveModel::Serializer
  include Biblio::StylesHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include Rails.application.routes.url_helpers
  
  attributes :id, :citation
  attribute :type do
    object.type.demodulize
  end
  attribute :cite do
    strip_tags apa(object).strip
  end


end