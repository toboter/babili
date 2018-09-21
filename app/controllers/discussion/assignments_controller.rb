module Discussion
  class AssignmentsController < ApplicationController
    load_resource :namespace
    load_resource :repository
    load_and_authorize_resource :thread, through: :repository, find_by: :sequential_id
    load_and_authorize_resource :assignment, through: :thread

    def index
      set_meta_tags title: 'Assignments | ' + view_context.truncate(@thread.title, length: 10) + ' | ' + @repository.name_tree.reverse.join(' | '),
                    description: "Assignments for #{@thread.title}",
                    noindex: true,
                    follow: true
      @assignees = Namespace.all-@thread.assignees
      respond_to do |format|
        format.html { render layout: 'repositories/base' if @repository.present? }
        format.js
      end
    end

    def new
      set_meta_tags title: 'Assign person | ' + view_context.truncate(@thread.title, length: 8) + ' | ' + @repository.name_tree.reverse.join(' | '),
                    description: "Assigns a new person to #{@thread.title}"
      @assignees = Namespace.all-@thread.assignees
      @assignment.assigner = current_user.person
      respond_to do |format|
        format.html { render layout: 'repositories/base' if @repository.present? }
        format.js
      end
    end

    def create
      @assignment.assigner = current_user.person

      respond_to do |format|
        if @assignment.save
          @assignees = Namespace.all-@thread.assignees
          format.html { redirect_to [@namespace, @thread.discussable, :discussion, @thread], notice: 'Assignment was successfully created.' }
          format.json { render :show, status: :created }
          format.js
        else
          format.html { render :new }
          format.json { render json: @assignment.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @assignment.destroy
      respond_to do |format|
        @assignees = Namespace.all-@thread.assignees
        format.html { redirect_to [@namespace, @thread.discussable, :discussion, @thread], notice: 'Assignment was successfully removed.' }
        format.json { head :no_content }
        format.js
      end
    end

    private
    def assignment_params
      params.require(:assignment).permit(:id, :assignee_id)
    end
  end
end

