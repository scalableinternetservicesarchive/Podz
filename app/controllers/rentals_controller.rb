class RentalsController < ApplicationController

  def rent
    item_id = params[:item_id]
    item = Item.find_by(id: item_id)
    if item == nil || !item.available
      flash[:danger] = "Item is currently checked out"
    else
      item.available = false
      item.save
      rental = Rental.new(item_id: item_id, user_id: current_user.id)
      rental.save
      flash[:success] = "Item was rented"
    end

    redirect_to items_path
  end

  def check_in
    item_id = params[:item_id]
    item = Item.find(item_id)
    item.available = true
    item.save
    rental = Rental.find_by(item_id: item_id, user_id: current_user.id)
    rental.check_in_date = DateTime.now
    rental.history = true
    rental.save
    flash[:success] = "Item is now checked in. Feel free to write a review to elaborate on your experience!"
    redirect_to item_path(item)

  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def rental_params
      params.require(:rental).permit(:item_id, :user_id, :length_days, :length_hours, :note)
    end
end
