class SearchController < ApplicationController

  def index
    if params[:q]
      @apps = Search::Application.all
      @results =[]
      @apps.each do |app|
        resp = nil
        instance_variable_set("@#{app.name}_url", "#{app.url}?q=#{params[:q]}")
        uri = URI(instance_variable_get("@#{app.name}_url"))
        ## hier muss noch dazwischen geschaltet werden, falls der Server nicht erreichbar ist.
        resp = Net::HTTP.get_response(uri)
        @results.concat(JSON.parse(resp.body)) if resp
      end
    end
  end
  
end
