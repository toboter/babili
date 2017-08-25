module Oread
  class Oread::ApplicationsController < ApplicationController
    before_action :set_application, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!, except: [:index, :show]
    load_and_authorize_resource
    
    # GET /applications
    # GET /applications.json
    def index
      @applications = Application.all
    end

    # GET /applications/1
    # GET /applications/1.json
    def show
      @access_tokens = @application.access_tokens.where(resource_owner: current_user)
      @token = @access_tokens.last
    end

    # GET /applications/new
    def new
      @application = Application.new
    end

    # GET /applications/1/edit
    def edit
    end

    # POST /applications
    # POST /applications.json
    def create
      @application = Application.new(application_params)
      @application.owner = current_user

      respond_to do |format|
        if @application.save
          format.html { redirect_to @application, notice: 'Application was successfully created.' }
          format.json { render :show, status: :created, location: @application }
        else
          format.html { render :new }
          format.json { render json: @application.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /applications/1
    # PATCH/PUT /applications/1.json
    def update
      @application.owner = current_user if @application.owner.blank?

      respond_to do |format|
        if @application.update(application_params)
          format.html { redirect_to @application, notice: 'Application was successfully updated.' }
          format.json { render :show, status: :ok, location: @application }
        else
          format.html { render :edit }
          format.json { render json: @application.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /applications/1
    # DELETE /applications/1.json
    def destroy
      @application.destroy
      respond_to do |format|
        format.html { redirect_to url_for(Oread::Application), notice: 'Application was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_application
        @application = Oread::Application.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def application_params
        params.require(:oread_application).permit(:name, :host, :port, :search_path, :description, :image, :cached_image_data, 
          :owner_id, :owner_type, oread_accessibilities_attributes: [:id, :accessor, :access_granted, :access_expires_at, :_destroy])
      end
  end
end