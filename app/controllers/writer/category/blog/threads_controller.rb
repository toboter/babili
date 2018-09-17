require 'will_paginate/array'

module Writer
  module Category
    class Blog::ThreadsController < ApplicationController
      before_action :load_threads
      load_and_authorize_resource class: 'Writer::Category::BlogThread', except: :index, find_by: :slug, instance_name: :thread
      DEFAULT_PER_PAGE = 30
      layout 'writer/blog'

      def index
        @postings = @threads.accessible_by(current_ability).collect(&:postings).flatten.group_by(&:document).map{|d,c| c.first}.sort_by(&:created_at).reverse.paginate(page: params[:page], per_page: DEFAULT_PER_PAGE)
      end

      def show
        @postings = @thread.postings.order(created_at: :desc).paginate(page: params[:page], per_page: DEFAULT_PER_PAGE)
      end

      def new
      end

      def create
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
        respond_to do |format|
          if @thread.categorizations_count == 0 && !@thread.children.any?
            @thread.destroy
            format.html { redirect_to writer_category_blog_threads_path, notice: 'Thread was successfully removed.' }
            format.json { head :no_content }
          else
            format.html { redirect_to writer_category_blog_thread_path(@thread), notice: 'Cannot remove thread.' }
          end
        end
      end

      private
      def thread_params
        params.require(:thread).permit(
          :name
        )
      end

      def load_threads
        @threads = BlogThread.all
      end

    end
  end
end