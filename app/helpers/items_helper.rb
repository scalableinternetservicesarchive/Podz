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
    items = Item.all.sort_by { |item| [item.rating * (item.reviews.length > 2 ? 1 : 0), item.reviews.length] }
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

  def rental_length(start_date, end_date)

    seconds_diff = (start_date - end_date).to_i.abs

    days = (seconds_diff / 3600) / 24
    seconds_diff -= days * 24 * 3600

    hours = seconds_diff / 3600
    seconds_diff -= hours * 3600

    days_display = ""
    if days > 0
      days_display = "#{days.to_s.rjust(1, '0')} days, "
    end

    hours_display = ""
    if hours > 0
      hours_display = "#{hours.to_s.rjust(1, '0')} hours, "
    end

    minutes = seconds_diff / 60

    minutes_display = ""
    if minutes > 0
      minutes_display = "#{minutes.to_s.rjust(1, '0')} minutes"
    end


    seconds_diff -= minutes * 60

    seconds = seconds_diff
    seconds_display = "#{seconds.to_s.rjust(1, '0')}"

    days_display + hours_display + minutes_display


  end

  # Returns the keyword_search display
  def search_display
    @keyword_display = if !@keyword.nil? && @keyword.length.positive?
                         @keyword
                       else
                         'Search by Keyword'
                       end
  end

  def display_availability(availability)
    @available_display = if availability
                           'Available'
                         else
                           'Rented'
                         end
  end

  def cache_key_for_top_item(item)
    "item/#{item.top_item.id}/#{item.top_item.updated_at}/#{item.top_item.item_id}"
  end

  def cache_key_for_top_item_table
    "top_item_table/#{TopItem.maximum(:updated_at)}"
  end
end
