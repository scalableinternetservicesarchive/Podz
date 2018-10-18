require 'test_helper'

class ItemCreationTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "Item created by user should be associated with that user" do
    item = Item.new(title: "New Item", description: "This is a new item", )
    log_in_as(@user)
    post items_path, params: { item: { title: item.title, description: item.description } }
    created_item = Item.find_by(title: item.title, description: item.description, user_id: @user.id)
    assert_not_nil created_item
  end

end
