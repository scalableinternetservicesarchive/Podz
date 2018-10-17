require 'test_helper'

class AdminActionsTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)
    @nonadmin = users(:archer)
  end

  test "Non-admins should not be able to create a category" do
    log_in_as(@nonadmin)
    post categories_path, params: { category: { title: "test", description: "also a test" } }
    assert_redirected_to root_path
  end

  test "Admins should be able to create a category" do
    log_in_as(@admin)
    post categories_path, params: { category: { title: "test", description: "also a test" } }
    follow_redirect!
    assert_template 'categories/show'
  end

end
