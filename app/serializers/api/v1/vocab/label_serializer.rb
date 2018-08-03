module Api::V1::Vocab
  class LabelSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers
    type :label

    attributes :type, :body, :language

    attribute :abbreviation do
      object.is_abbrevation?
    end

    attributes :vernacular, :historical

  end
end