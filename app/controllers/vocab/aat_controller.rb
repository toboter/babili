class Vocab::AATController < ApplicationController
  def index
    @concepts = Vocab::AAT.facets
  end

  def show
    @concept = Vocab::AAT.find(params[:id])

    uri = "http://vocab.getty.edu/aat/#{params[:id]}.jsonld?inference=all"
    begin
      response = RestClient.get(uri)
      obj = JSON.parse(response.body)
    rescue Errno::ECONNREFUSED
      "Server at #{uri} is refusing connection."
      obj = nil
    end
    @concept_jsonld = JSON.pretty_generate(obj)
  end
  
end