class CMS::HelpCategoriesController < ApplicationController

  def show
    @category = CMS::HelpCategory.friendly.find(params[:id])
  end

end