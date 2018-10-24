module UsersHelper

  # Returns the top n users based on ratings
  def get_top_users(n: 10)
    users = User.all.sort_by { |user| user.rating }
    users.reverse!
    users[0..n]
  end

end
