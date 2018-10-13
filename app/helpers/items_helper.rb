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
end
