class SearchController < ApplicationController
  require 'rest-client'
  require 'json'
  include ERB::Util

  def index
    set_meta_tags title: 'Search',
                  description: 'Search results page'

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
      @local_results = Searchkick.search(params[:q], 
        fields: [{citation: :exact}, :author, :editor, :title, :booktitle, :journal, :series, {year: :exact}, :publisher, :address, "tag^10", 
          :volume, :number, :note, :isbn, :url, :doi, :abstract, :type, 'narrower^4', :scheme, 'labels^10', :broader, :notes, :matches],
        index_name: [Vocab::Concept, Biblio::Entry])
    end
  end
end