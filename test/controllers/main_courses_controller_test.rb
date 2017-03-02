require 'test_helper'

class MainCoursesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get main_courses_home_url
    assert_response :success
  end

end
