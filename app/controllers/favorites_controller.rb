class FavoritesController < ApplicationController

  def favorite
    puts params
    Favorite.create!(user_id: current_user.id, item_id: params[:item_id])
    redirect_to items_path
  end

  def unfavorite
    puts params
    @favorite = Favorite.find_by(user_id: current_user.id, item_id: params[:item_id])
    @favorite.destroy!
    redirect_to items_path
  end
end
