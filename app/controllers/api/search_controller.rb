class Api::SearchController < Api::BaseController
  skip_authorization_check
  # Mit allen verfügbaren Tokens, die von oauth/apps ausgestellt werden, kann auf /api/search zugegriffen werden.

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
        app_user_token = app.try(:access_tokens).where(resource_owner_id: current_user.id).last
        instance_variable_set("@#{app.name.parameterize.underscore}_url", "#{app.url}?q=#{url_encode(params[:q])}")
        url = instance_variable_get("@#{app.name.parameterize.underscore}_url")
        begin
          response = RestClient.get(url, {:Authorization => "#{app_user_token.try(:token_type)} #{app_user_token.try(:token)}"})
        rescue Errno::ECONNREFUSED
          puts "Server at #{url} is refusing connection."
        end
        @results.concat(JSON.parse(response)) if response
      end
      @grouped_results = @results.group_by { |r| r['type'] }
    end
    render json: @grouped_results
  end
end