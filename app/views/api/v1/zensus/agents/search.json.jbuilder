json.agents @agents do |agent|
  json.merge! zensus_agent_json(agent)
end
json.meta @meta if @meta
