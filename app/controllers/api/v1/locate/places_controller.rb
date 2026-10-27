module Api::V1::Locate
  class PlacesController < Api::V1::BaseController
    load_and_authorize_resource :place, class: 'Locate::Place', find_by: :id

    def index
      sort_order = Locate::Place.sorted_by(params[:sort].presence || 'updated_at_desc')
      @places = @places.paginate(page: params[:page], per_page: params[:per_page] || 30).order(sort_order)
      @meta = pagination_dict(@places)
      render template: "api/v1/locate/places/index"
    end

    def show
      render template: "api/v1/locate/places/show"
    end
    
  end
end