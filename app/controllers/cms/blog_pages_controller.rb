class CMS::BlogPagesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource instance_name: :blog, class: 'CMS::BlogPage', find_by: :slug, except: :index
  
  # GET /blogs
  # GET /blogs.json
  def index
    @blogs = CMS::BlogPage.featured.order(created_at: :desc)
    @categories = CMS::BlogCategory.order(name: :asc)
    @unpublished_blogs = CMS::BlogPage.where(author: current_person).unpublished if user_signed_in?
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
    @categories = CMS::BlogCategory.order(name: :asc)
    @unpublished_blogs = CMS::BlogPage.where(author: current_person).unpublished if user_signed_in?
  end

  # GET /blogs/new
  def new
  end

  # GET /blogs/1/edit
  def edit
  end

  # POST /blogs
  # POST /blogs.json
  def create
    @blog.author = current_person
    @blog.published_at = Time.now if params[:commit] == 'Publish now'
    
    respond_to do |format|
      if @blog.save
        format.html { redirect_to @blog, notice: "Blog was successfully created." }
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blogs/1
  # PATCH/PUT /blogs/1.json
  def update
    @blog.published_at = Time.now if params[:commit] == 'Publish now'
    respond_to do |format|
      if @blog.update(blog_page_params)
        format.html { redirect_to @blog, notice: "Blog was successfully updated." }
        format.json { render :show, status: :ok, location: @blog }
      else
        format.html { render :edit }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def move
    if ["move_lower", "move_higher", "move_to_top", "move_to_bottom", "insert"].include?(params[:method])
      respond_to do |format|
        if params[:method] == 'insert' && @blog.position.nil?
          pos = type_class.where.not(position: nil).order('position').last.try(:position) || 0
          if @blog.insert_at(pos+1)
            format.html { redirect_to type_class, notice: "#{@type} was successfully inserted to list." }
          else
            format.html { render :index }
          end
        else 
          if @blog.send(params[:method])
            format.html { redirect_to type_class, notice: "Position was successfully updated." }
          else
            format.html { render :index }
          end
        end
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.json
  def destroy
    @blog.destroy
    respond_to do |format|
      format.html { redirect_to cms_blog_pages_path, notice: "Blog was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_page_params
      params.require(:cms_blog_page).permit(:type, :category_id, :featured, :title, :content, further_reading: [])
    end
end
