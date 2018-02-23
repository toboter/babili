require 'test_helper'

class Locate::PlacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @locate_place = locate_places(:one)
  end

  test "should get index" do
    get locate_places_url
    assert_response :success
  end

  test "should get new" do
    get new_locate_place_url
    assert_response :success
  end

  test "should create locate_place" do
    assert_difference('Locate::Place.count') do
      post locate_places_url, params: { locate_place: { center: @locate_place.center } }
    end

    assert_redirected_to locate_place_url(Locate::Place.last)
  end

  test "should show locate_place" do
    get locate_place_url(@locate_place)
    assert_response :success
  end

  test "should get edit" do
    get edit_locate_place_url(@locate_place)
    assert_response :success
  end

  test "should update locate_place" do
    patch locate_place_url(@locate_place), params: { locate_place: { center: @locate_place.center } }
    assert_redirected_to locate_place_url(@locate_place)
  end

  test "should destroy locate_place" do
    assert_difference('Locate::Place.count', -1) do
      delete locate_place_url(@locate_place)
    end

    assert_redirected_to locate_places_url
  end
end
