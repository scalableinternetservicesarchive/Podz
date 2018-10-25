module ReviewsHelper

  def display_item_title(review)
    @item_title = Item.find_by(id: review.item_id).title
  end
end
