require 'test_helper'

class UserPostTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup

    @user = users(:christian)

  end

  #test "invalid post should not increment the amount of posts" do

    #log_in_as(@user)

    #get kitchen_path

    #assert_no_difference 'Post.count' do

      #post posts_path, params: { post: {title: "",
                                            #description: ""}}

    #end

    #assert_template 'posts/new'

  #end
end
