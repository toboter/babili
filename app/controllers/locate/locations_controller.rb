class Locate::LocationsController < ApplicationController
  load_and_authorize_resource :place
  load_and_authorize_resource through: :place

  def index
    set_meta_tags title: "Locations | #{@place.default_name} | Locate",
                  description: "Listing locations for #{@place.default_name}",
                  noindex: true,
                  follow: true
  end

  def show
    set_meta_tags title: "Location | #{@place.default_name} | Locate",
                  description: "Detail view for location",
                  index: true,
                  follow: true
  end

  def new
    set_meta_tags title: "New | Locations | #{@place.default_name} | Locate"
  end

  def edit
    set_meta_tags title: "Edit | Locations | #{@place.default_name} | Locate"
  end

  def create
    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @location.update(place_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locate_places_url, notice: 'Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:locate_location).permit(
        :id,
        :place_id,
        :loc,
        :fuzzyness
      )
    end
end
