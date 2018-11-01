class RentalsController < ApplicationController

  def rent
    item_id = params[:item_id]
    item = Item.find_by(id: item_id)
    if item.nil? || !item.available
      flash[:danger] = "Item is currently checked out"
    else
      ActiveRecord::Base.transaction do
        item.update(available: false)
        Rental.create(item_id: item_id, user_id: current_user.id)
      end
      flash[:success] = "Item was rented"
    end

    redirect_to items_path
  end

  def check_in
    item_id = params[:item_id]
    item = Item.find_by(id: item_id)
    if item.nil? || item.available
      flash[:danger] = "Item is already checked in"
    else
      rental = Rental.find_by(item_id: item_id, user_id: current_user.id)
      ActiveRecord::Base.transaction do
        item.update(available: true)
        rental.update(check_in_date: DateTime.now, history: true)
      end
      flash[:success] = "Item was checked in"
    end

    redirect_to current_user

  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def rental_params
      params.require(:rental).permit(:item_id, :user_id, :length_days, :length_hours, :note)
    end
end
