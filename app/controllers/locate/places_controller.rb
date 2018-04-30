class Locate::PlacesController < ApplicationController
  load_and_authorize_resource

  # GET /locate/places
  # GET /locate/places.json
  def index
  end

  # GET /locate/places/1
  # GET /locate/places/1.json
  def show
  end

  # GET /locate/places/new
  def new
  end

  # GET /locate/places/1/edit
  def edit
  end

  # POST /locate/places
  # POST /locate/places.json
  def create
    @place.creator = current_person
    
    respond_to do |format|
      if @place.save
        format.html { redirect_to @place, notice: 'Place was successfully created.' }
        format.json { render json: @place.toponyms.first }
      else
        format.html { render :new }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locate/places/1
  # PATCH/PUT /locate/places/1.json
  def update
    respond_to do |format|
      if @place.update(place_params)
        format.html { redirect_to @place, notice: 'Place was successfully updated.' }
        format.json { render :show, status: :ok, location: @place }
      else
        format.html { render :edit }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locate/places/1
  # DELETE /locate/places/1.json
  def destroy
    @place.destroy
    respond_to do |format|
      format.html { redirect_to locate_places_url, notice: 'Place was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def place_params
      params.require(:locate_place).permit(
        :type, 
        :description,
        datings_attributes: [
          :id,
          :dating_id,
          :_destroy,
          toponyms_attributes: [
            :id,
            :type,
            :denomination,
            :descriptor,
            :language,
            :_destroy
          ]
        ]
      )
    end
end
