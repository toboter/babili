class Vocab::ConceptsController < ApplicationController
  before_action :set_language
  load_and_authorize_resource :scheme
  load_and_authorize_resource through: :scheme, find_by: :slug

  def index
    @concepts = @concepts.roots
  end

  def show
    @definition = @concept.definitions.where(language: @language).first || @concept.definitions.first
    @other_definitions = @concept.definitions-[@definition]
  end

  def new
    @concept.broader_concept_ids = [Vocab::Concept.friendly.find(params[:broader_concept]).id] if params[:broader_concept]
    @concept.type = params[:type] ? params[:type] : 'Concept'
    @concept.labels.build
    @concept.notes.build
  end

  def edit
  end

  # POST /vocabularies/:id/concepts
  # POST /vocabularies/:id/concepts.json
  def create
    @concept.creator = current_user
    respond_to do |format|
      if @concept.save
        format.html { redirect_to vocab_scheme_concept_path(@scheme, @concept), notice: 'Concept was successfully created.' }
        format.json { render :show, status: :created, location: @concept }
      else
        format.html { render :new }
        format.json { render json: @concept.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vocabularies/:id/concepts/1
  # PATCH/PUT /vocabularies/:id/concepts/1.json
  def update
    respond_to do |format|
      if @concept.update(concept_params)
        format.html { redirect_to vocab_scheme_concept_path(@scheme, @concept), notice: "Concept was successfully updated." }
        format.json { render :show, status: :ok, location: @concept }
      else
        format.html { render :edit }
        format.json { render json: @concept.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vocabularies/:id/concepts/1
  # DELETE /vocabularies/:id/concepts/1.json
  def destroy
    @concept.destroy
    respond_to do |format|
      format.html { redirect_to vocab_scheme_concepts_path(@scheme), notice: 'Concept was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_language
    @language = LanguageList::LanguageInfo.find(browser.accept_language.first.part.split('-').first).to_s
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def concept_params
    params.require(:concept).permit(
      :uuid, 
      :status, 
      :type,
      broader_concepts: [],
      narrower_concepts: [],
      matches_attributes: [:id, :associated_concept, :property, :_destroy],
      labels_attributes: [:id, :type, :creator_id, :body, :language, :vernacular, :historical, :is_abbrevation, :_destroy],
      notes_attributes: [:id, :type, :creator_id, :body, :language, :_destroy])
  end
  
end