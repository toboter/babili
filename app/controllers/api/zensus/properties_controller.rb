class Api::Zensus::PropertiesController < Api::BaseController
  skip_authorization_check
  
  def index
    @properties = ::Zensus::Activity.properties
    render json: @properties
  end

  def show
    @property = ::Zensus::Activity.properties.select {|p| p[:id] == params[:id].to_i  }.first
    render json: @property
  end
end