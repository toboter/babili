module Writer
  module Category
    class Blog::PostingsController < ApplicationController
      load_resource :thread, class: 'Writer::Category::BlogThread'
      before_action :load_posting
      layout 'writer/blog'

      def show
        set_meta_tags title: "#{view_context.truncate(@posting.title, length: 28)} | Postings | Blog",
                      index: true,
                      follow: true
        authorize! :read, @posting
      end

      private
      def load_posting
        @posting = Writer::Categorization.order(created_at: :asc).joins(:document).where('extract(year from writer_categorizations.created_at) = ? AND extract(month from writer_categorizations.created_at) = ? AND writer_documents.slug = ?', params[:year], params[:month], params[:id]).first
      end

    end
  end
end