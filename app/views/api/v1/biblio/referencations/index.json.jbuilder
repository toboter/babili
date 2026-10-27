json.citation_data_items @results do |entry|
  json.merge! citation_data_item_json(entry)
end
