class FavoritesController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to? :js
  skip_before_action :verify_authenticity_token

  def favorite
    @item = Item.find_by(id: params[:item_id])
    Favorite.create!(user_id: current_user.id, item_id: params[:item_id])
    respond_to do |format|
      format.js
      format.html { redirect_to items_path }
    end
  end

  def unfavorite
    @item = Item.find_by(id: params[:item_id])
    @favorite = Favorite.find_by(user_id: current_user.id, item_id: params[:item_id])
    @favorite.destroy!
    respond_to do |format|
      format.js
      format.html { redirect_to items_path }
    end
  end

  def favorite_ajax_response
    item_ids = params[:item_ids]
    current_user_id = current_user.nil? ? nil : current_user.id
    @favorites = Favorite.where(item_id: item_ids, user_id: current_user_id)

    respond_to do |format|
      format.js
    end
  end
end
