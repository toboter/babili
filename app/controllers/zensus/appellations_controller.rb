class Zensus::AppellationsController < ApplicationController
  load_and_authorize_resource
  DEFAULT_PER_PAGE = 50

  def index
    query = params[:q].presence || '*'
    per_page = current_user.try(:person).try(:per_page).present? ? current_user.person.per_page : DEFAULT_PER_PAGE

    @appellations = Zensus::Appellation.search(query, 
      fields: [:name],
      misspellings: {below: 2},
      order: {order_name: :asc}, 
      page: params[:page], 
      per_page: per_page)

    respond_to do |format|
      format.html
      format.json { render json: @appellations }
    end
  end

  def show
  end

  def new
    @appellation.appellation_parts.build
  end

  def edit
  end

  def create
    respond_to do |format|
      if @appellation.save
        format.html { redirect_to zensus_name_url(@appellation), notice: 'Name was successfully created.' }
        format.json { render json: @appellation, methods: [:name] }
      else
        format.html { render :new }
        format.json { render json: @appellation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @appellation.update(appellation_params)
        format.html { redirect_to zensus_name_url(@appellation), notice: "Name was successfully updated." }
        format.json { render :show, status: :ok, location: @appellation  }
      else
        format.html { render :edit }
        format.json { render json: @appellation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @appellation.destroy unless @appellation.agent
    respond_to do |format|
      format.html { redirect_to zensus_names_path, notice: (@appellation.agent ? 'You have to remove the name through the agent' : 'Name was successfully removed.') }
      format.json { head :no_content }
    end
  end

  private
  def appellation_params
    params.require(:zensus_name).permit(
      :language, 
      :period, 
      :trans, 
      :agent_id,
      :name,
      appellation_parts_attributes: [
        :id,
        :type,
        :body,
        :preferred,
        :_destroy
      ]
    )
  end

end