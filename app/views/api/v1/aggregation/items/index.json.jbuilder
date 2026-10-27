json.items @items do |item|
  json.merge! aggregation_item_json(item)
end
json.meta @meta if @meta
