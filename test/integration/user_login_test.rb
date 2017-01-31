require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  #Also include a test for the flash. Sometimes the flash will stay for an "extra page" because it last for a redirect
  #not for another 'render' (which does not generate another request).
  test "invalid user login" do

    get login_path

    post login_path, params: { session: {name: "", password: ""}}

    assert_template 'sessions/new'

    assert_not flash.empty?

    get root_path

    assert flash.empty?
  end
end
