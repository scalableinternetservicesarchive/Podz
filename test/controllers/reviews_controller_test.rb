require 'test_helper'

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @review = reviews(:one)
    @user = users(:michael)
    @item = items(:one)
  end

  test "should get index" do
    get reviews_url
    assert_response :success
  end

  test "should get new" do
    get new_review_url
    assert_redirected_to login_path
    follow_redirect!
    assert_not flash.empty?
  end

  test "should create review" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user

    assert_difference('Review.count') do
      post reviews_url, params: { review: { anonymous: @review.anonymous, body: @review.body, item_id: @item.id, rating: @review.rating, title: @review.title, user_id: @user.id} }
    end

    assert_redirected_to @item
  end

  test "should show review" do
    get review_url(@review)
    assert_response :success
  end

  test "should get edit" do
    log_in_as(@user)
    get edit_review_url(@review)
    assert_response :success
  end

  test "should update review" do
    log_in_as(@user)
    patch review_url(@review), params: { review: { anonymous: @review.anonymous, body: @review.body, item_id: @review.item_id, rating: @review.rating, title: @review.title, user_id: @review.user_id } }
    assert_redirected_to User.find(@review.user_id)
  end

  test "shouldn't update review" do
    log_in_as(@user)
    patch review_url(@review), params: { review: { anonymous: @review.anonymous, body: @review.body, item_id: @review.item_id, rating: 6, title: @review.title, user_id: @review.user_id } }
    assert_not_equal @review.reload.rating, 6
  end

  test "should destroy review" do
    log_in_as(@user)
    assert_difference('Review.count', -1) do
      delete review_url(@review)
    end
    assert_redirected_to User.find(@review.user_id)
  end
end
