require 'test_helper'

class AdminActionsTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)
    @nonadmin = users(:archer)
    @category = categories(:one)
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

  test "Non-admins should not see categories in the header" do
    log_in_as(@nonadmin)
    get root_path
    assert_select "a[href=?]", categories_path, count: 0
  end

  test "Admins should see categories in the header" do
    log_in_as(@admin)
    get root_path
    assert_select "a[href=?]", categories_path, count: 1
  end

  test "Non-admins should not be able to update categories" do
    log_in_as(@nonadmin)
    name = "new title"
    description = "new description"
    patch category_path(@category), params: { category: { name: name, description: description } }
    assert_redirected_to root_path
    @category.reload
    assert_not_equal @category.name, name
    assert_not_equal @category.description, description
  end

  test "Non-admins should not be able to delete categories" do
    log_in_as(@nonadmin)
    delete category_path(@category)
    assert_not_nil Category.find_by(id: @category.id)
  end

end
