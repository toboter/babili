module Discussion
  class ThreadsController < ApplicationController
    DEFAULT_PER_PAGE = 50
    load_resource :namespace
    load_resource :repository

    load_resource :book, class: 'Biblio::Entry', instance_name: :entry
    load_resource :in_book, class: 'Biblio::Entry', instance_name: :entry
    load_resource :collections, class: 'Biblio::Entry', instance_name: :entry
    load_resource :in_collections, class: 'Biblio::Entry', instance_name: :entry
    load_resource :proceedings, class: 'Biblio::Entry', instance_name: :entry
    load_resource :in_proceedings, class: 'Biblio::Entry', instance_name: :entry
    load_resource :article, class: 'Biblio::Entry', instance_name: :entry
    load_resource :miscs, class: 'Biblio::Entry', instance_name: :entry
    load_resource :manuals, class: 'Biblio::Entry', instance_name: :entry
    load_resource :booklets, class: 'Biblio::Entry', instance_name: :entry
    load_resource :mastertheses, class: 'Biblio::Entry', instance_name: :entry
    load_resource :phdtheses, class: 'Biblio::Entry', instance_name: :entry
    load_resource :techreports, class: 'Biblio::Entry', instance_name: :entry
    load_resource :unpublisheds, class: 'Biblio::Entry', instance_name: :entry

    load_and_authorize_resource :thread, through: [:repository, :entry], find_by: :sequential_id
    
  
    def index
      parent = @entry.presence || @repository
      query = params[:q].presence || '*'
      #sorted_by = params[:sorted_by] ||= (params[:q].present? ? 'score_desc' : 'year_asc')
      #sort_order = Biblio::Entry.sorted_by(sorted_by) if @all_entries.any?
  
      per_page = current_user.try(:person).try(:per_page).present? ? current_user.person.per_page : DEFAULT_PER_PAGE
  
      @results = Discussion::Thread.search(query, 
        fields: [:is, :title, :author],
        where: { discussable_type: parent.class.name, discussable_id: parent.id },
        page: params[:page], 
        per_page: per_page
        ) do |body|
        body[:query][:bool][:must] = { query_string: { query: query, default_operator: "and" } }
      end

      render layout: 'repo' if @repository.present?
    end

    def show
      @items = @thread.items.sort_by{|e| e[:created_at]}
      render layout: 'repo' if @repository.present?
    end

    def new
      render layout: 'repo' if @repository.present?
    end

    def edit
    end

    def create
      @thread.author = current_user.person
      @thread.titles.build(content: thread_params[:title], author: current_user.person)
      @thread.comments.each{|c| c.author = current_user.person}

      respond_to do |format|
        if @thread.save
          format.html { redirect_to [@namespace, @thread.discussable, :discussion, @thread], notice: 'Thread was successfully created.' }
          format.json { render :show, status: :created, location: @thread }
        else
          format.html { render :new }
          format.json { render json: @thread.errors, status: :unprocessable_entity }
        end
      end
    end
  
     def update
      @thread.titles.build(content: thread_params[:title], changed_content: @thread.title, author: current_user.person)
      respond_to do |format|
        if @thread.update(thread_params)
          format.html { redirect_to [@namespace, @thread.discussable, :discussion, @thread], notice: "Thread title was successfully updated." }
          format.json { render :show, status: :ok, location: @thread }
          format.js
        else
          format.html { render :edit }
          format.json { render json: @thread.errors, status: :unprocessable_entity }
        end
      end
    end

    def close
      @thread.close_thread!(current_user.person)
      respond_to do |format|
        if @thread.save
          format.html { redirect_to [@namespace, @thread.discussable, :discussion, @thread], notice: 'Thread was successfully closed.' }
          format.json { render :show, status: :created, location: @thread }
        else
          format.html { render :new }
          format.json { render json: @thread.errors, status: :unprocessable_entity }
        end
      end
    end

    def toggle_lock
      @thread.locked? ? @thread.unlock_thread!(current_user.person) : @thread.lock_thread!(current_user.person)
      respond_to do |format|
        if @thread.save
          format.html { redirect_to [@namespace, @thread.discussable, :discussion, @thread], notice: 'Thread locked/unlocked.' }
          format.json { render :show, status: :created, location: @thread }
        else
          format.html { render :new }
          format.json { render json: @thread.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @thread.destroy
      respond_to do |format|
        format.html { redirect_to [@namespace, @thread.discussable, :discussion, :threads], notice: 'Thread was successfully removed.' }
        format.json { head :no_content }
      end
    end


    private
    def thread_params
      params.require(:thread).permit(
        :title, 
        comments_attributes: [
          :id,
          :author_id,
          versions_attributes: [
            :id,
            :body
          ]
        ]
      )
    end

  end
end