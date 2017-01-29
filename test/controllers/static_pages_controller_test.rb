require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get home_path
    assert_response :success
  end

  test "should get buffet" do
    get buffet_path
    assert_response :success
  end

  test "should get kitchen" do
    get kitchen_path
    assert_response :success
  end

end
