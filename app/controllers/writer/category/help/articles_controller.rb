module Writer
  module Category
    class Help::ArticlesController < ApplicationController
      load_resource :category, class: 'Writer::Category::HelpCategory'
      before_action :load_article
      layout 'writer/help'

      def show
        set_meta_tags title: "#{view_context.truncate(@article.title, length: 25)} | Articles | Help",
                      index: true,
                      follow: true
        authorize! :read, @article
      end

      private
      def load_article
        @article = Writer::Categorization.order(created_at: :asc).joins(:document).where('writer_documents.slug = ?', params[:id]).first
      end

    end
  end
end