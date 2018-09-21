class Vocab::SchemesController < ApplicationController
  load_and_authorize_resource :namespace
  load_and_authorize_resource :scheme, through: :namespace
  before_action :check_resource_location, only: :show
  before_action :set_language

  def index
    set_meta_tags title: 'Vocabularies | ' + @namespace.name,
                  description: "Listing vocabulary schemes for #{@namespace.name}",
                  noindex: true,
                  follow: true
    # Sind in Organisationen die Vokabulare der Mitglieder automatisch Teil des Organisationsvokabulars?
    # @schemes = (@schemes + @namespace.accessors.map(&:namespace).map(&:schemes).flatten).uniq
    # Vocab::Scheme.new(abbr: 'aat', title: 'Art and Architecture Thesaurus', slug: 'aat')
  end

  def show
    set_meta_tags title: "#{@scheme.abbr} | Vocabularies | #{@namespace.name}",
                  description: "#{@scheme.title} (#{@scheme.abbr}), #{@scheme.definition}",
                  index: true,
                  follow: true
  end

  def new
    set_meta_tags title: "New | Vocabularies | #{@namespace.name}"
  end

  def edit
    set_meta_tags title: "Edit | Vocabularies | #{@namespace.name}"
  end

  # POST /vocabularies
  # POST /vocabularies.json
  def create
    @scheme.creator = current_person
    respond_to do |format|
      if @scheme.save
        format.html { redirect_to [@namespace, :vocab, @scheme], notice: 'Vocabulary was successfully created.' }
        format.json { render :show, status: :created, location: @scheme }
      else
        format.html { render :new }
        format.json { render json: @scheme.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vocabularies/1
  # PATCH/PUT /vocabularies/1.json
  def update
    respond_to do |format|
      if @scheme.update(scheme_params)
        format.html { redirect_to [@namespace, :vocab, @scheme], notice: "Vocabulary was successfully updated." }
        format.json { render :show, status: :ok, location: @scheme }
      else
        format.html { render :edit }
        format.json { render json: @scheme.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vocabularies/1
  # DELETE /vocabularies/1.json
  def destroy
    @scheme.destroy
    respond_to do |format|
      format.html { redirect_to namespace_vocab_schemes_path(@namespace), notice: 'Vocabulary was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_language
    @language = LanguageList::LanguageInfo.find(browser.accept_language.first.part.split('-').first).to_s
  end

  def check_resource_location
    if request.path != namespace_vocab_scheme_path(@namespace, @scheme)
      return redirect_to namespace_vocab_scheme_path(@namespace, @scheme), :status => :moved_permanently
    end
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def scheme_params
    params.require(:scheme).permit(:abbr, :title, :definition, :namespace_id)
  end
end