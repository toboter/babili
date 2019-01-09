class Vocab::ConceptsController < ApplicationController
  load_and_authorize_resource :namespace
  load_and_authorize_resource :scheme, through: :namespace
  load_and_authorize_resource :concept, through: :scheme, find_by: :slug
  before_action :set_language

  def index
    set_meta_tags title: "Concepts | #{@scheme.abbr} | Vocabularies | #{@namespace.name}",
                  description: "Concepts in #{@scheme.title}",
                  noindex: true,
                  follow: true

    if params[:q].present?
      @concepts = Vocab::Concept.search(params[:q], 
        fields: [:type, :narrower, 'labels^20', 'notes^5', :matches], 
        where: { id: @concepts.ids })
      @flat = true
    end
    respond_to do |format|
      format.html
      format.json { render json: @concepts, each_serializer: ConceptSerializer }
    end

  end

  def show
    set_meta_tags title: "#{@concept.name} | Concepts | #{@namespace.name}",
                  description: "#{@concept.name}, #{@concept.definitions.try(:first).try(:body)}",
                  index: true,
                  follow: true
    @definition = @concept.definitions.where(language: @language).first || @concept.definitions.first
    @other_definitions = @concept.notes-[@definition]

    respond_to do |format|
      format.html
      format.json { render json: @concept, serializer: ConceptSerializer }
    end

  end

  def new
    set_meta_tags title: "New | Concepts | #{@namespace.name}"
    @concept.broader_concept_ids = [Vocab::Concept.friendly.find(params[:broader_concept]).id] if params[:broader_concept]
    @concept.type = params[:type] ? params[:type] : 'Concept'
    @concept.labels.build
    @concept.notes.build
  end

  def edit
    set_meta_tags title: "Edit | Concepts | #{@namespace.name}"
  end

  # POST /vocabularies/:id/concepts
  # POST /vocabularies/:id/concepts.json
  def create
    @concept.creator = current_person
    respond_to do |format|
      if @concept.save
        format.html { redirect_to namespace_vocab_scheme_concept_path(@namespace, @scheme, @concept), notice: 'Concept was successfully created.' }
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
        format.html { redirect_to namespace_vocab_scheme_concept_path(@namespace, @scheme, @concept), notice: "Concept was successfully updated." }
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
      format.html { redirect_to namespace_vocab_scheme_concepts_path(@namespace, @scheme), notice: 'Concept was successfully destroyed.' }
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
      matches_attributes: [
        :id, 
        :associated_concept, 
        :property, 
        :_destroy
      ],
      labels_attributes: [
        :id, 
        :type, 
        :creator_id, 
        :body, 
        :language, 
        :vernacular, 
        :historical, 
        :is_abbrevation, 
        :_destroy
      ],
      notes_attributes: [
        :id, 
        :type, 
        :creator_id, 
        :body, 
        :language, 
        :_destroy
      ]
    )
  end
  
end