class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :edit, :update, :destroy, :move]
  before_action :set_type
  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource
  
  # GET /blogs
  # GET /blogs.json
  def index
    @blogs = type_class.all
    @blog_years = @blogs.order(posted_at: :desc).group_by { |t| t.posted_at.strftime('%Y') }
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
  end

  # GET /blogs/new
  def new
    @blog = type_class.new
  end

  # GET /blogs/1/edit
  def edit
  end

  # POST /blogs
  # POST /blogs.json
  def create
    @blog = Blog.new(blog_params)

    respond_to do |format|
      if @blog.save
        format.html { redirect_to (@type == 'Novelity' ? novelities_path : @blog), notice: "#{@type} was successfully created." }
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
    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to @blog, notice: "#{@type} was successfully updated." }
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
      format.html { redirect_to send("#{@type.underscore.pluralize}_url"), notice: "#{@type} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_type
      @type = type
    end
    
    def type
      Blog.types.include?(params[:type]) ? params[:type] : "Blog"
    end
    
    def type_class
      type.constantize
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = type_class.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_params
      params.require(type.underscore.to_sym).permit(:type, :author_id, :title, :abstract, :content, :external_link, :posted_at)
    end
end
