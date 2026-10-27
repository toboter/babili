module Aggregation::Event::SheetExtraction
  extend ActiveSupport::Concern

  def extract_row(data, primary_id_label, columns: nil)
    key = primary_id_label.to_s.downcase
    payload = data.is_a?(Hash) ? data : {}
    {
      identifier: {
        value: payload[key].presence || payload[primary_id_label],
        type: primary_id_label,
        source: creator.name,
        label: primary_id_label.to_s.camelize
      },
      payload: payload,
      # jsonb does not keep hash key order — persist spreadsheet column order explicitly.
      columns: Array(columns.presence || payload.keys).map(&:to_s)
    }
  end
end
