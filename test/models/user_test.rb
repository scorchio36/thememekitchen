require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = User.new(name:"Example User", email:"user@example.com",
                    password: "foobar", password_confirmation:"foobar")
  end

  test "User should be valid" do
    assert @user.valid?
  end

  #presence validations
  test "username and email should be present" do

    @user.name = ""
    @user.email = ""
    @user.password = @user.password_confirmation = ""*6

    assert_not @user.valid?

  end


  #length validations
  test "username should not be too long" do

    @user.name = "a"*31

    assert_not @user.valid?

  end

  #databases can typically only store an email of 255 characters
  test "email should not be too long" do

    @user.name = "a"*244 + "@example.com"

    assert_not @user.valid?

  end

  test "username should not be too short" do

    @user.name = "a"*5

    assert_not @user.valid?

  end

  test "password should not be too short" do

    @user.password = @user.password_confirmation = "a"*5

    assert_not @user.valid?

  end

  #email format validations
  test "valid emails should be accepted" do

    valid_emails = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]

    valid_emails.each do |valid_email|

      @user.email = valid_email

      assert @user.valid?, "#{valid_email.inspect} should be valid"

    end
  end

  test "invalid emails should be rejected" do

    invalid_emails = %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com]

    invalid_emails.each do |invalid_email|

      @user.email = invalid_email

      assert_not @user.valid?, "#{invalid_email} should be invalid"
    end
  end


  #uniqeness tests
  test "email addresses should be unique" do

    duplicate_user = @user.dup

    duplicate_user.name = @user.name.upcase
    duplicate_user.email = @user.email.upcase

    @user.save

    assert_not duplicate_user.valid?

  end


end
