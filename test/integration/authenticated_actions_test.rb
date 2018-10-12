require 'test_helper'

class AuthenticatedActionsTest < ActionDispatch::IntegrationTest

  test "unauthenticated user should not be able to make items" do
    get new_item_path
    assert_redirected_to signup_path
    follow_redirect!
    assert_not flash.empty?
  end

end
