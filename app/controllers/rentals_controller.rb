class RentalsController < ApplicationController

  def rent
    item_id = params[:item_id]
    item = Item.find(item_id)
    item.available = false
    item.save
    rental = Rental.new(item_id: item_id, user_id: current_user.id)
    rental.save

    respond_to do |format|
      format.html { redirect_to items_path, notice: 'Item was rented', class: 'rented_text' }
      format.json { head :no_content }
    end
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

    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Item was checked in', class: 'rented_text' }
      format.json { head :no_content }
    end

  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def rental_params
      params.require(:rental).permit(:item_id, :user_id, :length_days, :length_hours, :note)
    end
end
