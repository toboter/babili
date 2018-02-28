class PeopleController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource :find_by => :slug
  layout "settings", except: [:index, :show]

  def index
    @people = Person.order(family_name: :asc)
  end

  def show
  end

  def edit
    @person = current_person
  end

  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to edit_current_person_path, flash: { notice: 'Profile was updated successfully.' } }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:about_me, :family_name, :given_name, :honorific_prefix, :honorific_suffix, :image, :url, :institution, :location)
    end
end
