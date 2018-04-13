class Locate::PlaceSerializer <  ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  type :place

  attributes :type, :id, :default_name


end
