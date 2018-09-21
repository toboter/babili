require 'will_paginate/array'

module Writer
  module Category
    class Help::CategoriesController < ApplicationController
      before_action :load_categories
      load_and_authorize_resource class: 'Writer::Category::HelpCategory', except: :index, find_by: :slug, instance_name: :category
      DEFAULT_PER_PAGE = 30
      layout 'writer/help'

      def index
        set_meta_tags title: "Overview | Help",
                      description: "Listing all help categories with articles",
                      noindex: true,
                      follow: true
        @articles = @categories.accessible_by(current_ability).collect(&:articles).flatten.group_by(&:document).map{|d,c| c.first}.sort_by(&:created_at).reverse.paginate(page: params[:page], per_page: DEFAULT_PER_PAGE)
      end

      def show
        set_meta_tags title: "#{@category.name} | Categories | Help",
                      description: "Listing all help categories and articles below #{@category.name}",
                      noindex: true,
                      follow: true
        @articles = @category.articles.order(created_at: :desc).paginate(page: params[:page], per_page: DEFAULT_PER_PAGE)
      end

      def new
        set_meta_tags title: "New category | Help"
        @category.parent = HelpCategory.friendly.find(params[:parent]) if params[:parent]
      end

      def create
        @category.creator = current_person
        respond_to do |format|
          if @category.save
            format.html { redirect_to writer_category_help_category_path(@category), notice: 'Category was successfully created.' }
            format.json { render :show, status: :created, location: @category }
            format.js
          else
            format.html { render :new }
            format.json { render json: @category.errors, status: :unprocessable_entity }
            format.js
          end
        end
      end

      def destroy
        respond_to do |format|
          if @category.categorizations_count == 0 && !@category.children.any?
            @category.destroy
            format.html { redirect_to writer_category_help_categories_path, notice: 'Category was successfully removed.' }
            format.json { head :no_content }
          else
            format.html { redirect_to writer_category_help_category_path(@category), notice: 'Cannot remove category.' }
          end
        end
      end

      private
      def category_params
        params.require(:category).permit(
          :name,
          :parent_id
        )
      end

      def load_categories
        @categories = HelpCategory.all
      end

    end
  end
end