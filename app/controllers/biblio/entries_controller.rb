class Biblio::EntriesController < ApplicationController
  before_action :set_type
  load_and_authorize_resource except: :index

  # GET /bibliography/entries
  # GET /bibliography/entries.json
  def index
    @entries = type_class.all
  end

  # GET /bibliography/entries/1
  # GET /bibliography/entries/1.json
  def show
  end

  # GET /bibliography/entries/new
  def new 
    @creators = Zensus::Appellation.all
    @entry = type_class.new
    instance_variable_set("@#{@entry.class.name.demodulize.underscore}", @entry)
  end

  # GET /bibliography/entries/1/edit
  def edit
    @creators = Zensus::Appellation.all
    instance_variable_set("@#{@entry.class.name.demodulize.underscore}", @entry)
  end

  # POST /bibliography/entries
  # POST /bibliography/entries.json


  # DELETE /bibliography/entries/1
  # DELETE /bibliography/entries/1.json
  def destroy
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to biblio_entries_url, notice: "#{@type.demodulize} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_type
      @type = type
    end
    
    def type
      Biblio::Entry.types.include?(params[:type]) ? params[:type] : "Biblio::Entry"
    end
    
    def type_class
      type.constantize
    end

  end