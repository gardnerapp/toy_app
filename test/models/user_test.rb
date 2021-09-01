require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = "     "
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" *51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" *244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-er@foo.bar.org
                        first.last@foo.jp alice+bob@bar.cn]
    valid_addresses.each do |address|
      @user.email =address
      assert @user.valid?, "#{address} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                          foo@bar_bax.com foo@bar+bax.com]
    invalid_addresses.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address} should be invalid"
    end
  end

  test "email should be unique " do
    duplicate = @user.dup
    @user.save
    duplicate.email.upcase
    assert_not duplicate.valid?
  end

  test "emails should be saved downcase" do
    mixed_case = "ExaMPLE22@example.com"
    @user.email = mixed_case
    @user.save
    assert_equal @user.email, mixed_case.downcase
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = "   "
    assert_not @user.valid?
  end

  test "password should have minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for nil digest" do
    assert_not @user.authenticated?('')
  end
end
