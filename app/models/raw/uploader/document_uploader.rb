module Raw::Uploader
  class DocumentUploader < BaseUploader

    Attacher.validate do
      validate_mime_type_inclusion Raw::Document::TYPES
    end

    # We are creating a preview for pdfs
    #https://stackoverflow.com/a/47652854

    Attacher.derivatives do |original|
      if DocumentUploader.determine_mime_type(io) == "application/pdf"
        preview = Tempfile.new(["shrine-pdf-preview", ".pdf"], binmode: true)
        begin
          IO.popen %W[mudraw -F png -o - #{io.download.path} 1], "rb" do |command|
            IO.copy_stream(command, preview)
          end
        rescue Errno::ENOENT
          fail "mutool is not installed"
        end

        preview.open # flush & rewind
      end

      {
        original: original,
        preview:  preview
      }
    end


  end
end
