class Api::SearchController < Api::BaseController
  require 'rest-client'
  require 'json'
  include ERB::Util

  skip_before_action :doorkeeper_authorize!
  skip_before_action :authenticate_user_with_doorkeeper!
  skip_authorization_check

  before_action :authenticate_user_with_personal_token!
  before_action  -> { authorize_personal_api_methods(:search) }, only: :index
  
  def index
    if params[:q].present?
      @apps = current_user.present? ? current_user.oread_enrolled_applications : Oread::Application.where(enroll_users_default: true)
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
          puts "Server at #{url} is refusing connection."
        end
        @results.concat(JSON.parse(response)) if response
      end
      @grouped_results = @results.group_by { |r| r['type'] }
    end
    render json: @grouped_results
  end

end