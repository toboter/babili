module Api
  module V1
    module Raw
      class FileUploadsController < Api::V1::BaseController
        before_action :set_klass, only: :create
        load_and_authorize_resource except: :create, find_by: :slug, class: 'Raw::FileUpload'
        
        def show
          render json: @file_upload, serializer: FileUploadSerializer
        end

        def view_file
          #uploaded_file = @file_upload.file.is_a?(Hash) ? @file_upload.file.fetch(params[:version].present? ? params[:version].to_sym : :original) : @file_upload.file
          uploaded_file = @file_upload.is_a?(Hash) ? (params[:version].present? ? @file_upload.file(params[:version].to_sym) : @file_upload.file) : @file_upload.file

          headers["Content-Length"] = uploaded_file.size
          headers["Content-Type"] = uploaded_file.mime_type
          headers["Content-Disposition"] = "inline; filename=\"#{uploaded_file.metadata['filename']}\""
      
          self.response_body = Enumerator.new do |yielder|
            yielder << uploaded_file.read(16*1024) until uploaded_file.eof?
            uploaded_file.close
          end
        end

        def create
          @file_upload = @klass.new(resource_params)
          @file_upload.uploader = current_user.person
          authorize! :create, @file_upload

          # if a file already exists with the same md5 checksum, this will be returned.
          @existing = ::Raw::FileUpload.find_by_file_signature(@file_upload.file_signature)

          if @existing.present? ? (@file_upload = @existing) : @file_upload.save
            render status: :created, json: @file_upload, serializer: FileUploadSerializer
          else
            render json: @file_upload.errors, status: :unprocessable_entity
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
              when /^image\//       then ::Raw::Image
              when /^audio\//       then ::Raw::Audio
              when /^video\//       then ::Raw::Video
              when /^application\// then ::Raw::Document
              when /^text\//        then ::Raw::Document
              else ::Raw::FileUpload
            end
          else
            @klass = ::Raw::FileUpload
          end
        end
      end
    end
  end
end
