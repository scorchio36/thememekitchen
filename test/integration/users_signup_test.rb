require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end


  test "User count should not change on invalid form submission" do

    get signup_path

    assert_no_difference 'User.count' do

      post users_path, params: { user: { name: "",
                                          email: "",
                                            password:"",
                                              password_confirmation: ""}}

    end

    assert_template 'users/new'

  end

  test "User count should increase on valid form submission" do

    get signup_path

    assert_difference 'User.count', 1 do

      post users_path, params: { user: { name: "Example User",
                                          email: "user@example.com",
                                            password:"foobar",
                                              password_confirmation: "foobar"}}

    end

    follow_redirect!

    assert_template 'users/show'

  end
end
