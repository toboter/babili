require 'test_helper'

class Raw::FileUploadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @raw_file_upload = raw_file_uploads(:one)
  end

  test "should get index" do
    get raw_file_uploads_url
    assert_response :success
  end

  test "should get new" do
    get new_raw_file_upload_url
    assert_response :success
  end

  test "should create raw_file_upload" do
    assert_difference('Raw::FileUpload.count') do
      post raw_file_uploads_url, params: { raw_file_upload: { upload_data: @raw_file_upload.upload_data } }
    end

    assert_redirected_to raw_file_upload_url(Raw::FileUpload.last)
  end

  test "should show raw_file_upload" do
    get raw_file_upload_url(@raw_file_upload)
    assert_response :success
  end

  test "should get edit" do
    get edit_raw_file_upload_url(@raw_file_upload)
    assert_response :success
  end

  test "should update raw_file_upload" do
    patch raw_file_upload_url(@raw_file_upload), params: { raw_file_upload: { upload_data: @raw_file_upload.upload_data } }
    assert_redirected_to raw_file_upload_url(@raw_file_upload)
  end

  test "should destroy raw_file_upload" do
    assert_difference('Raw::FileUpload.count', -1) do
      delete raw_file_upload_url(@raw_file_upload)
    end

    assert_redirected_to raw_file_uploads_url
  end
end
