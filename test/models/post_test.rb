require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup

    @user = users(:christian)
    @post = @user.posts.build(title:"Funny Title", description: "Cool description")

  end

  test "post should be valid" do

    assert @post.valid?

  end

  test "title should be present" do

    @post.title = ""

    assert_not @post.valid?

  end

  test "title and description should not be too long" do

    @post.title = "a"*51
    @post.description = "a"*51

    assert_not @post.valid?

  end


end
