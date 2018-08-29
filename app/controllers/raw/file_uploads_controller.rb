class Raw::FileUploadsController < ApplicationController
  before_action :set_klass, only: :create
  load_and_authorize_resource except: :create, find_by: :slug
  layout 'raw'
  
  # GET /raw/file_uploads/1
  # GET /raw/file_uploads/1.json
  def show
  end

  # GET /raw/file_uploads/new
  def new
    @file_upload = Raw::FileUpload.new
  end

  # POST /raw/file_uploads
  # POST /raw/file_uploads.json
  def create
    @file_upload = @klass.new(resource_params)
    @file_upload.uploader = current_user.person
    authorize! :create, @file_upload

    # if a file already exists with the same md5 checksum, this will be returned.
    @existing = Raw::FileUpload.find_by_file_signature(@file_upload.file_signature)

    respond_to do |format|
      if @existing.present? ? (@file_upload = @existing) : @file_upload.save
        format.html { redirect_to raw_file_upload_path(@file_upload), notice: 'File was successfully created.' }
        format.json { render json: @file_upload, status: :created, serializer: Raw::FileUploadSerializer }
      else
        format.html { render :new }
        format.json { render json: @file_upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /raw/file_uploads/1
  # DELETE /raw/file_uploads/1.json
  def destroy
    @file_upload.destroy
    respond_to do |format|
      format.html { redirect_to raw_path, notice: 'File was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      params.require(:upload).permit(:file, :creator, :file_copyright)
    end

    def set_klass
      file = resource_params[:file]
      if file.present?
        @klass = case file.try(:tempfile).present? ? Marcel::MimeType.for(Pathname.new(file.tempfile)) : JSON.parse(file)['metadata']['mime_type']
          when /^image\//       then Raw::Image
          when /^audio\//       then Raw::Audio
          when /^video\//       then Raw::Video
          when /^application\// then Raw::Document
          when /^text\//        then Raw::Document
          else Raw::FileUpload
        end
      else
        @klass = Raw::FileUpload
      end
    end
end
