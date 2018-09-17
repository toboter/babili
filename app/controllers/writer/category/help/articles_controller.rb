module Writer
  module Category
    class Help::ArticlesController < ApplicationController
      load_resource :category, class: 'Writer::Category::HelpCategory'
      layout 'writer/help'

      def show
        @article = Writer::Categorization.friendly.find(params[:id])
        authorize! :read, @article
      end

    end
  end
end