module Aggregation::Event::SheetExtraction 
  extend ActiveSupport::Concern

  included do
  end

  def extract_row(data, primary_id_label)
    data = { 
      identifier: {
        value: data[primary_id_label.downcase],
        type: primary_id_label,
        source: self.creator.name,
        label: primary_id_label.camelize
      },
      payload: data
    }
    return data
  end
end