module Writer
  module Category
    class Blog::PostingsController < ApplicationController
      load_resource :thread, class: 'Writer::Category::BlogThread'
      layout 'writer/blog'

      def show
        @posting = Writer::Categorization.order(created_at: :asc).joins(:document).where('extract(year from writer_categorizations.created_at) = ? AND extract(month from writer_categorizations.created_at) = ? AND writer_documents.slug = ?', params[:year], params[:month], params[:id]).first
        authorize! :read, @posting
      end

    end
  end
end