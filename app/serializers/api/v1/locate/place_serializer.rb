module Api::V1::Locate
  class PlaceSerializer <  ActiveModel::Serializer
    include Rails.application.routes.url_helpers
    type :place

    attributes :type, :id, :default_name


  end
end