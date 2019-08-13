module Api::V1::Vocab
      class ConceptsController < Api::V1::BaseController
        load_and_authorize_resource :scheme, class: 'Vocab::Scheme', only: [:index, :show]
        load_and_authorize_resource :concept, through: :scheme, class: 'Vocab::Concept', find_by: :slug, only: [:index, :show]

        # /api/scheme/:slug/concepts
        def index
          sort_order = Vocab::Concept.sorted_by(params[:sort].presence || 'updated_at_desc')
          @concepts = @concepts.where("updated_at > ?", params[:since]) if params[:since]
          @concepts = @concepts.paginate(page: params[:page], per_page: params[:per_page] || 30).order(sort_order)

          @concepts = @concepts.where(type: params[:type]) if params[:type]
          if params[:synsets] == 'true'
            render json: @concepts.map{|c| c.labels.map(&:body)}
          else
            render json: @concepts, meta: pagination_dict(@concepts), each_serializer: ConceptSerializer, adapter: :json
          end
        end

        # /api/scheme/:slug/concepts/:slug
        def show
          if params[:synsets] == 'true'
            render json: @concept.labels.map(&:body)
          else
            render json: @concept, serializer: ConceptSerializer, adapter: :json
          end
        end

        # /api/vocab/concepts
        def full_index
          @concepts = ::Vocab::Concept.accessible_by(current_ability, :read)
          sort_order = ::Vocab::Concept.sorted_by(params[:sort].presence || 'updated_at_desc')
          @concepts = @concepts.where(scheme_id: ::Vocab::Scheme.friendly.find(params[:in_scheme])) if params[:in_scheme]
          @concepts = @concepts.where("updated_at > ?", params[:since]) if params[:since]
          @concepts = @concepts.paginate(page: params[:page], per_page: params[:per_page] || 30).order(sort_order)

          @concepts = @concepts.where(type: params[:type]) if params[:type]

          authorize! :read, ::Vocab::Concept
          if params[:synsets] == 'true'
            render json: @concepts.map{|c| c.labels.map(&:body)}
          else
            render json: @concepts, meta: pagination_dict(@concepts), each_serializer: ConceptSerializer, adapter: :json
          end
        end

        # /api::/v1/search/concepts
        def search
          concepts = ::Vocab::Concept.accessible_by(current_ability, :read)
          concepts = concepts.where(scheme_id: ::Vocab::Scheme.friendly.find(params[:in_scheme])) if params[:in_scheme]

          @results = ::Vocab::Concept.search(params[:q],
            fields: [:type, 'narrower^4', :scheme, 'labels^10', :broader, :notes, :matches],
            where: {id: concepts.ids},
            page: params[:page], 
            per_page: params[:per_page] || 30)

          authorize! :read, ::Vocab::Concept
          if params[:synsets] == 'true'
            @results = @results.take(params[:limit].to_i) if params[:limit]
            render json: @results.map{|c| c.labels.map(&:body)}
          else
            render json: @results, meta: pagination_dict(@results), each_serializer: ConceptSerializer, adapter: :json
          end
        end

      end
end
