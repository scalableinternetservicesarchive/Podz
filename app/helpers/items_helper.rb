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
    @category_name = Category.find_by(id: category_id).name || "Uncategorized"
  end

  # Method returns top n items based on sum of ratings
  def get_top_items(n: 10)
    items = Item.all.sort_by { |item| item.rating }
    items.reverse!
    items[0..n]
  end

  def item_owned(user_id, item_user_id)
    if user_id == item_user_id
      true
    else
      false
    end

  end

  def item_rented(user_id, item_id)
    rental = Rental.where(user_id: user_id, item_id: item_id)
    if rental
      true
    else
      false
    end
  end

  # Returns the keyword_search display
  def search_display
    @keyword_display = if !@keyword.nil? && @keyword.length.positive?
                         @keyword
                       else
                         'Search by Keyword'
                       end
  end


end
