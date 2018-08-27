module Writer
  class DocumentsController < ApplicationController
    DEFAULT_PER_PAGE = 50
    before_action :set_paper_trail_whodunnit, except: [:index, :show]
    load_resource :namespace
    load_resource :repository
    load_and_authorize_resource :document, through: :repository, find_by: :sequential_id
    layout 'repo'

    def index
      query = params[:q].presence || '*'
      sorted_by = params[:sorted_by] ||= 'created_desc'
      sort_order = Writer::Document.sorted_by(sorted_by) if @documents.any?
  
      per_page = current_user.try(:person).try(:per_page).present? ? current_user.person.per_page : DEFAULT_PER_PAGE
  
      @results = Writer::Document.search(query, 
        fields: [:_all],
        where: { repository_id: @repository.id },
        order: sort_order,
        page: params[:page], 
        per_page: per_page
        ) do |body|
        body[:query][:bool][:must] = { query_string: { query: query, default_operator: "and" } }
      end
    end

    def show
    end

    def new
    end

    def edit
    end

    def create
      @document.creator = current_user.person
      respond_to do |format|
        if @document.save
          format.html { redirect_to [@namespace, @repository, @document], notice: 'Document was successfully created.' }
          format.json { render :show, status: :created, location: @document }
          format.js
        else
          format.html { render :new }
          format.json { render json: @document.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    def update
      respond_to do |format|
        if @document.update(document_params)
          format.html { redirect_to [@namespace, @repository, @document], notice: "Document was successfully updated." }
          format.json { render :show, status: :ok, location: @document }
          format.js
        else
          format.html { render :edit, notice: "Please review your input." }
          format.json { render json: @document.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    def destroy
      @document.destroy
      respond_to do |format|
        format.html { redirect_to [@namespace, @repository, :documents], notice: 'Document was successfully removed.' }
        format.json { head :no_content }
      end
    end

    private
    def document_params
      params.require(:document).permit(
        :title, 
        :content
      )
    end

  end
end