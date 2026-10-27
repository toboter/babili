json.repositories @repositories do |repository|
  json.merge! repository_json(repository)
end
json.meta @meta if @meta
