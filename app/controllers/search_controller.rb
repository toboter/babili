class SearchController < ApplicationController
  require "rest-client"
  require "json"
  include ERB::Util
  include OreadRemoteSearch

  def index
    set_meta_tags title: "Search",
                  description: "Search results page"

    return if params[:q].blank?

    @repos =
      if user_signed_in?
        current_user.oread_enrolled_applications
      else
        Oread::Application.where(enroll_users_default: true)
      end

    @results, @failed_connections = search_oread_remotes(params[:q])

    if @failed_connections.any?
      flash.now[:warning] =
        if @failed_connections.one?
          "Missing remote results: #{@failed_connections.first}. Connection error.".html_safe
        else
          "Missing remote results (#{@failed_connections.size}): #{@failed_connections.join(', ')}. Connection error.".html_safe
        end
    end

    @local_results = Searchkick.search(
      params[:q],
      fields: [
        { citation: :exact }, :author, :editor, :title, :booktitle, :journal, :series, { year: :exact },
        :publisher, :address, "tag^10", :volume, :number, :note, :isbn, :url, :doi, :abstract, :type,
        "narrower^4", :scheme, "labels^10", :broader, :notes, :matches
      ],
      index_name: [Vocab::Concept, Biblio::Entry]
    )
  end
end
