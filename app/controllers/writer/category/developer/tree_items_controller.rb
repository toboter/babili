require 'will_paginate/array'

module Writer
  module Category
    class Developer::TreeItemsController < ApplicationController
      before_action :load_tree_items, except: [:index, :create]
      authorize_resource class: 'Writer::Category::DeveloperTreeItem', except: [:index, :show]
      DEFAULT_PER_PAGE = 30
      layout 'writer/developer'

      def index
        set_meta_tags title: "Overview | Developer",
                      description: "Listing all developer api versions",
                      noindex: true,
                      follow: true
        @tree_roots = DeveloperTreeItem.roots
        @oread_applications = Oread::Application.order("RANDOM()")
      end

      def show
        set_meta_tags title: "#{@tree_item == @tree_root ? 'Overview' : @tree_item.name} | #{@tree_root.name} | Developer",
                      description: "Listing all developer api versions",
                      noindex: true,
                      follow: true
      end

      def new
        set_meta_tags title: "New element | Developer"
        @parent_item = @tree_item
        @tree_item = DeveloperTreeItem.new
        @tree_item.parent = @parent_item
      end

      def create
        @tree_item = DeveloperTreeItem.new(tree_item_params)
        @tree_item.creator = current_person
        respond_to do |format|
          if @tree_item.save
            format.html { redirect_to writer_category_developer_nested_item_path(@tree_item.root? ? nil : @tree_item.root, @tree_item.ancestors.where.not(id: @tree_item.root.id).reverse.map(&:slug).join('/').presence || nil, @tree_item), notice: 'Element was successfully created.' }
            format.json { render :show, status: :created, location: @tree_item }
            format.js
          else
            format.html { render :new }
            format.json { render json: @tree_item.errors, status: :unprocessable_entity }
            format.js
          end
        end
      end

      def destroy
        respond_to do |format|
          if @tree_item.categorizations_count == 0 && !@tree_item.children.any?
            @tree_item.destroy
            format.html { redirect_to writer_category_developer_tree_items_path, notice: 'Element was successfully removed.' }
            format.json { head :no_content }
          else
            format.html { redirect_to writer_category_developer_nested_item_path(@tree_item.root? ? nil : @tree_item.root, @tree_item.ancestors.where.not(id: @tree_item.root.id).reverse.map(&:slug).join('/').presence || nil, @tree_item), notice: 'Cannot remove element.' }
          end
        end
      end

      private
      def tree_item_params
        params.require(:tree_item).permit(
          :name,
          :parent_id
        )
      end

      def load_tree_items
        @tree_root = params[:root_id] ? DeveloperTreeItem.friendly.find(params[:root_id]) : DeveloperTreeItem.friendly.find(params[:id]) if params[:id]
        @tree_item = @tree_root.self_and_descendants.friendly.find(params[:id]) if @tree_root
        @tree_items = [@tree_root].concat(@tree_root.children) if @tree_root
      end

    end
  end
end