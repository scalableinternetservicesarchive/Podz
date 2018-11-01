require 'test_helper'

class AuthenticatedActionsTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unauthenticated user should not be able to make items" do
    get new_item_path
    assert_redirected_to login_path
    follow_redirect!
    assert_not flash.empty?
  end

  test "authenticated user should be able to make items" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    get new_item_path
    assert_template 'items/new'
    post items_path, params: { item: { title: "New Item",
                                       description: "This is a new item",
                                       category_id: 1,
                                       price_hourly_usd: 20,
                                       price_daily_usd: 100 },
                               condition: "Good",
                               user_lat: 0.0,
                               user_lng: 0.0}
    follow_redirect!
    assert_template "items/show"
  end

end
