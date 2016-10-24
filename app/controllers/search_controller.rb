class SearchController < ApplicationController
  include ERB::Util
  
  def index
    if params[:q].present?
      @apps = Search::Application.all
      @results =[]
      @apps.each do |app|
        resp = nil
        instance_variable_set("@#{app.name}_url", "#{app.url}?q=#{url_encode(params[:q])}")
        uri = URI(instance_variable_get("@#{app.name}_url"))
        ## hier muss noch dazwischen geschaltet werden, falls der Server nicht erreichbar ist.
        resp = Net::HTTP.get_response(uri)
        @results.concat(JSON.parse(resp.body)) if resp
      end
      @grouped_results = @results.group_by { |r| r['type'] }
    end
  end
  
end
