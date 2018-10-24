require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item = items(:one)
    @user = users(:michael)
  end

  #test "should get index" do
   # get items_url
   # assert_response :success
  #end

  test "should create item" do
    log_in_as(@user)
    assert_difference('Item.count') do
      post items_url, params: { item: { available: @item.available, description: @item.description, title: @item.title } }
    end
    assert_redirected_to item_url(Item.last)
    assert_equal @user.id, Item.last.user_id
  end

  #test "should show item" do
   # get item_url(@item)
    #assert_response :success
  #end

  test "should get edit" do
    log_in_as(@user)
    get edit_item_url(@item)
    assert_response :success
  end

  test "should update item" do
    log_in_as(@user)
    new_title = "new title"
    patch item_url(@item), params: { item: { title: new_title } }
    assert_redirected_to item_path(@item)
    assert_equal new_title, @item.reload.title
  end

  test "should destroy item" do
    log_in_as(@user)
    assert_difference('Item.count', -1) do
      delete item_url(@item)
    end

    assert_redirected_to items_url
  end
end
