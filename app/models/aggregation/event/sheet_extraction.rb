module Aggregation::Event::SheetExtraction 
  extend ActiveSupport::Concern

  included do
  end

  def extract_row(data, primary_id_label)
    data = { 
      identifier: {
        id: data['bab_rel'],
        type: primary_id_label,
        agent: self.creator.name,
        label: primary_id_label.camelize
      },
      payload: data
    }
    return data
  end
end