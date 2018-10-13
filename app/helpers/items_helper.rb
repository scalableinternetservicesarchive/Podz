module ItemsHelper
  # Given a User id, return the display name of the User
  def get_display_name(user_id)
    @user = User.find(user_id)
    @display_name = @user.display_name
  end
end
