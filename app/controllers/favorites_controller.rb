class FavoritesController < ApplicationController
  respond_to? :js

  def favorite
    @item = Item.find_by(id: params[:item_id])
    Favorite.create!(user_id: current_user.id, item_id: params[:item_id])
  end

  def unfavorite
    @item = Item.find_by(id: params[:item_id])
    @favorite = Favorite.find_by(user_id: current_user.id, item_id: params[:item_id])
    @favorite.destroy!
  end
end
