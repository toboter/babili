module Discussion
  class CommentsController < ApplicationController
    load_resource :namespace
    load_resource :repository
    load_and_authorize_resource :thread, through: :repository, find_by: :sequential_id
    load_and_authorize_resource :comment, through: :thread

    def new
      @comment.author = current_user.person
      render layout: 'repo' if @repository.present?
    end

    def edit
      respond_to do |format|
        format.html { render layout: 'repo' if @repository.present? }
        format.js
      end
    end

    def create
      @comment.author = current_user.person
      @comment.thread.open_thread!(current_user.person) unless @comment.thread.current_state.first == 'open'

      respond_to do |format|
        if @comment.save
          format.html { redirect_to [@namespace, @thread.discussable, :discussion, @thread], notice: 'Comment was successfully created.' }
          format.json { render :show, status: :created, location: @comment }
          format.js
        else
          format.html { render :new }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      @comment.versions.last.inspect
      @comment.versions.build(body: comment_params[:versions_attributes]['0']['body'])

      respond_to do |format|
        if @comment.save
          format.html { redirect_to [@namespace, @thread.discussable, :discussion, @thread], notice: 'Comment was successfully updated.' }
          format.json { render :show, status: :created, location: @comment }
          format.js
        else
          format.html { render :new }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @comment.destroy
      respond_to do |format|
        format.html { redirect_to [@namespace, @thread.discussable, :discussion, @thread], notice: 'Comment was successfully removed.' }
        format.json { head :no_content }
        format.js
      end
    end

    private
    def comment_params
      params.require(:comment).permit(
        :id,
        :author_id,
        versions_attributes: [
          :id,
          :body
        ]
      )
    end

  end
end