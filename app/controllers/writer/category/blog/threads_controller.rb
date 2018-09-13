require 'will_paginate/array'

module Writer
  module Category
    class Blog::ThreadsController < ApplicationController
      #load_and_authorize_resource
      DEFAULT_PER_PAGE = 30
      layout 'writer/blog'

      def index
        @threads = Blog.all
        @postings = @threads.collect(&:postings).flatten.sort_by(&:created_at).reverse.paginate(page: params[:page], per_page: DEFAULT_PER_PAGE)
      end

      def show
        @threads = Blog.all
        @thread = Blog.friendly.find(params[:id])
        @postings = @thread.postings.order(created_at: :desc).paginate(page: params[:page], per_page: DEFAULT_PER_PAGE)
      end

      def new
        @thread = Blog.new
      end

      def create
        @thread = Blog.new(thread_params)
        @thread.creator = current_person
        respond_to do |format|
          if @thread.save
            format.html { redirect_to writer_category_blog_thread_path(@thread), notice: 'Thread was successfully created.' }
            format.json { render :show, status: :created, location: @thread }
            format.js
          else
            format.html { render :new }
            format.json { render json: @thread.errors, status: :unprocessable_entity }
            format.js
          end
        end
      end

      def destroy
        @thread = Blog.friendly.find(params[:id])
        @thread.destroy
        respond_to do |format|
          format.html { redirect_to writer_category_blog_threads_path, notice: 'Thread was successfully removed.' }
          format.json { head :no_content }
        end
      end

      private
      def thread_params
        params.require(:thread).permit(
          :name
        )
      end

    end
  end
end