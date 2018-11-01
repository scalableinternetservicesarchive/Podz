require 'test_helper'

class RentalsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @rental = rentals(:one)
    @user = users(:michael)
    @item = items(:one)
  end

  test "should rent item then check item back in" do
    log_in_as(@user)
    assert_difference('Rental.count') do
      post rent_path(item_id: @item.id)
    end

    assert_redirected_to @item
    assert_equal Rental.last.item_id, @item.id

    post checkin_path(item_id: @item.id)
    assert Rental.last.history = true
  end

end
