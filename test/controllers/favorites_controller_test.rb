require 'test_helper'

class FavoritesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:michael)
    @item = items(:one)
  end

  test 'should create favorite' do
    log_in_as(@user)
    assert_difference('Favorite.count') do
      post favorite_url, params: { item_id: @item.id }
    end
  end

  test 'should destroy favorite on item destruction' do
    log_in_as(@user)
    post favorite_url, params: { item_id: @item.id }
    assert_difference('Favorite.count', -1) do
      delete item_url(@item)
    end
  end

  test 'should destroy favorite on user destruction' do
    log_in_as(@user)
    post favorite_url, params: {item_id: @item.id }
    assert_difference('Favorite.count', -1) do
      delete user_url(@user)
    end
  end
end
