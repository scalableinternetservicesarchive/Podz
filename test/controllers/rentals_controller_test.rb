require 'test_helper'

class RentalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rental = rentals(:one)
    @user = users(:michael)
    @item = items(:one)
  end

  test "should get index" do
    get rentals_url
    assert_response :success
  end

  test "should get new" do
    get new_rental_url
    assert_response :success
  end

  test "should create rental" do
    assert_difference('Rental.count') do
      post rentals_url, params: { rental: { item_id: @item.id, length_days: @rental.length_days, length_hours: @rental.length_hours, note: @rental.note, user_id: @user.id } }
    end

    assert_redirected_to rental_url(Rental.last)
  end

  test "should get edit" do
    get edit_rental_url(@rental)
    assert_response :success
  end

end
