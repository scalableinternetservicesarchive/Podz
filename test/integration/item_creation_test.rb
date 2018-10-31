require 'test_helper'

class ItemCreationTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "Item created by user should be associated with that user" do
    item = Item.new(title: "New Item", description: "This is a new item", price_hourly_usd: "20", price_daily_usd: "100" )
    log_in_as(@user)
    post items_path, params: { item: { title: item.title, description: item.description, category_id: item.category_id, price_hourly_usd: item.price_hourly_usd, price_daily_usd: item.price_daily_usd },
                               condition: item.condition, user_lat: item.latitude, user_lng: item.longitude}
    created_item = Item.find_by(title: item.title, description: item.description, category_id: item.category_id, condition: item.condition, price_hourly_usd: item.price_hourly_usd, price_daily_usd: item.price_daily_usd, user_id: @user.id)
    assert_not_nil created_item
  end

end
