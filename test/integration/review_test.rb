require 'test_helper'

class ReviewTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @item = items(:one)
  end

  test "review on item page should redirect to item page" do
    log_in_as(@user)
    get item_path(@item)
    assert_template "items/show"
    post reviews_path params: { review: { item_id: @item.id } }
    assert_redirected_to items_path(@item)
  end

end
