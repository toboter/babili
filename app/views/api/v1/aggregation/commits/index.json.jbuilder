json.commits @commits do |commit|
  json.merge! aggregation_commit_json(commit)
end
json.meta @meta if @meta
