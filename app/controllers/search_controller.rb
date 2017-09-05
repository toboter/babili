class SearchController < ApplicationController
  require 'rest-client'
  require 'json'
  include ERB::Util

  def index
    if params[:q].present?
      @apps = Oread::Application.all
      @results =[]
      @failed_connections = []
      @apps.each do |app|
        response = nil
        app_user_token = app.try(:access_tokens).where(resource_owner: current_user).last
        instance_variable_set("@#{app.name.parameterize.underscore}_url", "#{app.url}?q=#{url_encode(params[:q])}")
        url = instance_variable_get("@#{app.name.parameterize.underscore}_url")
        begin
          response = RestClient.get(url, {:Authorization => "#{app_user_token.try(:token_type)} #{app_user_token.try(:token)}"})
        rescue Errno::ECONNREFUSED
          @failed_connections << url
          puts "Server at #{url} is refusing connection. Err No #{@failed_connections.count}"
        end
        flash.now[:notice] = @failed_connections.count == 1 ? "Results from #{@failed_connections.first.to_s} missing. Can't connect to server." : "Multiple connections failing. Results from #{@failed_connections.join(', ')} missing." if @failed_connections.count > 0
        @results.concat(JSON.parse(response)) if response
      end
      @grouped_results = @results.group_by { |r| r['type'] }
    end
  end
end