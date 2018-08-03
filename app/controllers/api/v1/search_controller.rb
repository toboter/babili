module Api::V1
  class SearchController < Api::V1::BaseController
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
        @repos = user_signed_in? ? current_user.oread_enrolled_applications : Oread::Application.where(enroll_users_default: true)
        @results =[]
        @failed_connections = []
        @repos.each do |repo|
          response = nil
          repo_user_token = repo.try(:access_tokens).where(resource_owner: current_user).last
          repo.collection_classes.each do |rclass|
            #instance_variable_set("#{repo.name.parameterize.underscore}_url", "#{rclass.repo_api_url}?q=#{url_encode(params[:q])}")
            url = "#{rclass.repo_api_url}?q=#{url_encode(params[:q])}"
            begin
              response = RestClient.get(url, {:Authorization => "#{repo_user_token.try(:token_type)} #{repo_user_token.try(:token)}"})
            rescue Errno::ECONNREFUSED
              @failed_connections << "<strong>#{url}</strong> connection refused".html_safe
              puts "#{url} connection refused. Errcount #{@failed_connections.count}"
            end
            flash.now[:warning] = @failed_connections.count == 1 ? "Missing results: #{@failed_connections.first.to_s}. <br><strong>Connection error.</strong>".html_safe : "Missing results (#{@failed_connections.count}): #{@failed_connections.join(', ')}. <br><strong>Connection error.</strong>".html_safe if @failed_connections.count > 0
            @results << JSON.parse(response) if response
          end
        end
      end
      render json: @results
    end

  end
end