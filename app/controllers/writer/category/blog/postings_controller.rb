module Writer
  module Category
    class Blog::PostingsController < ApplicationController
      load_resource :thread, class: 'Writer::Category::Blog'
      layout 'writer/blog'

      def show
        @posting = Writer::Categorization.where('extract(year from created_at) = ? AND extract(month from created_at) = ?', params[:year], params[:month]).friendly.find(params[:id])
      end

    end
  end
end