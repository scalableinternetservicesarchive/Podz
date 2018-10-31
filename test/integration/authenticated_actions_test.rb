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
    item = Item.new(title: "New Item", description: "This is a new item", price_hourly_usd: "20", price_daily_usd: "100")

    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    get new_item_path
    assert_template 'items/new'
    post items_path, params: { item: { title: item.title, description: item.description, category_id: item.category_id, price_hourly_usd: item.price_hourly_usd, price_daily_usd: item.price_daily_usd },
                               condition: item.condition, user_lat: item.latitude, user_lng: item.longitude}
    follow_redirect!
    assert_template "items/show"
  end

end
