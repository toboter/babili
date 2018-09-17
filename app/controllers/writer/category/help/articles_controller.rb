module Writer
  module Category
    class Help::ArticlesController < ApplicationController
      load_resource :category, class: 'Writer::Category::HelpCategory'
      layout 'writer/help'

      def show
        @article = Writer::Categorization.order(created_at: :asc).joins(:document).where('writer_documents.slug = ?', params[:id]).first
        authorize! :read, @article
      end

    end
  end
end