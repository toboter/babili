module Api::V1::Zensus
  class AgentsController < Api::V1::BaseController
    load_and_authorize_resource class: 'Zensus::Agent', find_by: :slug

    def index
      sort_order = Zensus::Agent.sorted_by(params[:sort].presence || 'updated_at_desc')
      @agents = @agents.where("updated_at > ?", params[:since]) if params[:since]
      @agents = @agents.paginate(page: params[:page], per_page: params[:per_page] || 30).order(sort_order)

      @agents = @agents.where(type: params[:type]) if params[:type]
      @meta = pagination_dict(@agents)
      render template: "api/v1/zensus/agents/index"
    end

    def show
      render template: "api/v1/zensus/agents/show"
    end

    def search
      @agents = Zensus::Agent.search(params[:q],
        fields: ['name^10', :appellations, :activities],
        page: params[:page], 
        per_page: params[:per_page] || 30)

      @meta = pagination_dict(@agents)
      render template: "api/v1/zensus/agents/search"
    end
  end
end