module ItemsHelper
  # Given a User id, return the display name of the User
  def get_display_name(review)
    if review.anonymous
      @display_name = 'Anonymous'
    else
      @user = User.find(review.user_id)
      @display_name = @user.display_name
    end
  end

  def display_category(category_id)
    @category_name = Category.find(category_id).name
  end

  def item_owned(user_id, item_user_id)
    if user_id == item_user_id
      true
    else
      false
    end
  end
end
