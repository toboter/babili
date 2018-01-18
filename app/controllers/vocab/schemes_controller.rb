class Vocab::SchemesController < ApplicationController
  before_action :set_language
  load_and_authorize_resource find_by: :slug
  
  def index
    # Vocab::Scheme.new(abbr: 'aat', title: 'Art and Architecture Thesaurus', slug: 'aat')
  end

  def show
  end

  def new
  end

  def edit
  end

  # POST /vocabularies
  # POST /vocabularies.json
  def create
    @scheme.creator = current_user
    respond_to do |format|
      if @scheme.save
        format.html { redirect_to [:vocab, @scheme], notice: 'Vocabulary was successfully created.' }
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
        format.html { redirect_to [:vocab, @scheme], notice: "Vocabulary was successfully updated." }
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
      format.html { redirect_to vocab_schemes_path, notice: 'Vocabulary was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_language
    @language = LanguageList::LanguageInfo.find(browser.accept_language.first.part.split('-').first).to_s
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def scheme_params
    params.require(:scheme).permit(:abbr, :title, :definition)
  end
end