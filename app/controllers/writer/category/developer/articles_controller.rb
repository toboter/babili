module Writer
  module Category
    class Developer::ArticlesController < ApplicationController
      layout 'writer/developer'

      def show
        @tree_root = params[:root_id] ? DeveloperTreeItem.friendly.find(params[:root_id]) : DeveloperTreeItem.friendly.find(params[:tree_item_id])
        @tree_item = @tree_root.self_and_descendants.friendly.find(params[:tree_item_id])
        @tree_items = [@tree_root].concat(@tree_root.children)
        @article = @tree_item.articles.order(created_at: :asc).joins(:document).where('writer_documents.slug = ?', params[:id]).first
        authorize! :read, @article
      end

    end
  end
end