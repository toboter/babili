require "application_system_test_case"

class Raw::FileUploadsTest < ApplicationSystemTestCase
  setup do
    @raw_file_upload = raw_file_uploads(:one)
  end

  test "visiting the index" do
    visit raw_file_uploads_url
    assert_selector "h1", text: "Raw/File Uploads"
  end

  test "creating a File upload" do
    visit raw_file_uploads_url
    click_on "New Raw/File Upload"

    fill_in "Upload Data", with: @raw_file_upload.upload_data
    click_on "Create File upload"

    assert_text "File upload was successfully created"
    click_on "Back"
  end

  test "updating a File upload" do
    visit raw_file_uploads_url
    click_on "Edit", match: :first

    fill_in "Upload Data", with: @raw_file_upload.upload_data
    click_on "Update File upload"

    assert_text "File upload was successfully updated"
    click_on "Back"
  end

  test "destroying a File upload" do
    visit raw_file_uploads_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "File upload was successfully destroyed"
  end
end
