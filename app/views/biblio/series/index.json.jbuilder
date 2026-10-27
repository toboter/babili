json.series @serials do |serie|
  json.merge! biblio_serie_json(serie)
end
