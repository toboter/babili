module Writer
  module Category
    class Developer::ArticlesController < ApplicationController
      before_action :load_root
      before_action :load_item
      before_action :load_items
      before_action :load_article
      layout 'writer/developer'

      def show
        set_meta_tags title: "#{view_context.truncate(@article.title, length: 25)} | Articles | Developer",
                      index: true,
                      follow: true
        authorize! :read, @article
      end


      private
      def load_root
        @tree_root = params[:root_id] ? DeveloperTreeItem.friendly.find(params[:root_id]) : DeveloperTreeItem.friendly.find(params[:tree_item_id])
      end
      def load_item
        @tree_item = @tree_root.self_and_descendants.friendly.find(params[:tree_item_id])
      end
      def load_items
        @tree_items = [@tree_root].concat(@tree_root.children)
      end
      def load_article
        @article = @tree_item.articles.order(created_at: :asc).joins(:document).where('writer_documents.slug = ?', params[:id]).first
      end

    end
  end
end