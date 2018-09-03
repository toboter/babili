class Settings::NamespacesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_namespace
  layout "settings"


  def edit
    authorize! :edit, @namespace
  end


  def update
    authorize! :update, @namespace
    respond_to do |format|
      if @namespace.update(namespace_params)
        format.html { redirect_to [:edit, :settings, (@namespace.subclass.class.name == 'Person' ? :person : @namespace.subclass)], notice: "Namespace was successfully updated!" }
        format.json { render :show, status: :ok, location: @namespace  }
      else
        format.html { render :edit }
        format.json { render json: @namespace.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_namespace
      klass = params[:type].classify.constantize
      @namespace = params[:organization_id] ? klass.find(params[:organization_id]).namespace : current_person.namespace
    end

    def namespace_params
      params.require(:namespace).permit(:name)
    end
end