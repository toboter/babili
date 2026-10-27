json.names @appellations do |appellation|
  json.merge! zensus_appellation_json(appellation)
end
json.meta @meta if @meta
