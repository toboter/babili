class Api::Vocab::ConceptsController < Api::BaseController
  load_and_authorize_resource :scheme, class: 'Vocab::Scheme', find_by: :slug, except: [:full_index, :search, :synonyms]
  load_and_authorize_resource :concept, through: :scheme, class: 'Vocab::Concept', find_by: :slug, except: [:full_index, :search, :synonyms]

  # /api/scheme/:slug/concepts
  def index
    sort_order = Vocab::Concept.sorted_by(params[:sort].presence || 'updated_at_desc')
    @concepts = @concepts.where("updated_at > ?", params[:since]) if params[:since]
    @concepts = @concepts.paginate(page: params[:page], per_page: params[:per_page] || 30).order(sort_order)

    @concepts = @concepts.where(type: params[:type]) if params[:type]
    render json: @concepts, meta: pagination_dict(@concepts), each_serializer: Vocab::ConceptSerializer, adapter: :json
  end

  # /api/scheme/:slug/concepts/:slug
  def show
    render json: @concept, serializer: Vocab::ConceptSerializer, adapter: :json
  end

  # /api/vocab/concepts
  def full_index
    @concepts = ::Vocab::Concept.all
    sort_order = Vocab::Concept.sorted_by(params[:sort].presence || 'updated_at_desc')
    @concepts = @concepts.where(scheme_id: Vocab::Scheme.friendly.find(params[:in_scheme])) if params[:in_scheme]
    @concepts = @concepts.where("updated_at > ?", params[:since]) if params[:since]
    @concepts = @concepts.paginate(page: params[:page], per_page: params[:per_page] || 30).order(sort_order)

    @concepts = @concepts.where(type: params[:type]) if params[:type]
    authorize! :read, @concepts
    render json: @concepts, meta: pagination_dict(@concepts), each_serializer: Vocab::ConceptSerializer, adapter: :json
  end

  # /api/search/concepts
  def search
    concept_ids = ::Vocab::Concept.where(scheme_id: Vocab::Scheme.friendly.find(params[:in_scheme])).ids if params[:in_scheme]
    where_clause = {id: concept_ids} if params[:in_scheme]

    @concepts = ::Vocab::Concept.search(params[:q],
      fields: [:type, 'narrower^4', :scheme, 'labels^10', :broader, :notes, :matches],
      where: where_clause,
      page: params[:page], 
      per_page: params[:per_page] || 30)

    authorize! :read, @concepts
    render json: @concepts, meta: pagination_dict(@concepts), each_serializer: Vocab::ConceptSerializer, adapter: :json
  end

  def synonyms
    #to do
  end
end