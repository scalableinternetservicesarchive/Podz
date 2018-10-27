module UsersHelper

  # Returns the top n users based on ratings
  def get_top_users(n: 10)
    users = User.all.sort_by { |user| user.rating * user.items.length }
    users.reverse!
    users[0..n]
  end

  # Returns the users favorited items
  def get_favorites(user)
    @favorites = Favorite.where(user_id: user.id)
    unless @favorites.nil?
      item_ids = []
      @favorites.each do |favorite|
        item_ids << favorite.item_id
      end
      @favorite_items = Item.find(item_ids)
    end
  end

end
