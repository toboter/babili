json.file do
  json.merge! raw_file_upload_json(@file_upload, absolute_file_url: false)
end
