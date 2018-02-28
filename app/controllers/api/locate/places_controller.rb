class Api::Locate::PlacesController < Api::BaseController
  load_and_authorize_resource :place, class: 'Locate::Place', find_by: :id

  def index
    sort_order = Locate::Place.sorted_by(params[:sort].presence || 'updated_at_desc')
    @places = @places.paginate(page: params[:page], per_page: params[:per_page] || 30).order(sort_order)
    render json: @places, meta: pagination_dict(@places), each_serializer: Locate::PlaceSerializer, adapter: :json
  end

  def show
    render json: @place, serializer: Locate::PlaceSerializer, adapter: :json
  end
  
end