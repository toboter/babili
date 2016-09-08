class SearchController < ApplicationController

  def index
    if params[:q]
      @creatorship_url = "http://localhost:3001/api/citations/search.json?q=#{params[:q]}"
      @creatorship_resp = Net::HTTP.get_response(URI.parse(@creatorship_url))
      @results = JSON.parse(@creatorship_resp.body)
      @people_url = "http://localhost:3002/api/people/search.json?q=#{params[:q]}"
      @people_resp = Net::HTTP.get_response(URI.parse(@people_url))
      @results.concat(JSON.parse(@people_resp.body))
    end
  end
  
end
