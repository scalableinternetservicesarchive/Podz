class RentalsController < ApplicationController
  before_action :set_rental, only: [:show, :edit, :update, :destroy]

  # GET /rentals
  # GET /rentals.json
  def index
    @rentals = Rental.all
  end

  # GET /rentals/1
  # GET /rentals/1.json
  def show
  end

  # GET /rentals/new
  def new
    @rental = Rental.new
  end

  # GET /rentals/1/edit
  def edit
  end

  # POST /rentals
  # POST /rentals.json
  def create
    @rental = Rental.new(rental_params)

    respond_to do |format|
      if @rental.save
        format.html { redirect_to @rental, notice: 'Rental was successfully created.' }
        format.json { render :show, status: :created, location: @rental }
      else
        format.html { render :new }
        format.json { render json: @rental.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rentals/1
  # PATCH/PUT /rentals/1.json
  def update
    respond_to do |format|
      if @rental.update(rental_params)
        format.html { redirect_to @rental, notice: 'Rental was successfully updated.' }
        format.json { render :show, status: :ok, location: @rental }
      else
        format.html { render :edit }
        format.json { render json: @rental.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rentals/1
  # DELETE /rentals/1.json
  def destroy
    @rental.destroy
    respond_to do |format|
      format.html { redirect_to rentals_url, notice: 'Rental was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

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
    # Use callbacks to share common setup or constraints between actions.
    def set_rental
      @rental = Rental.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rental_params
      params.require(:rental).permit(:item_id, :user_id, :length_days, :length_hours, :note)
    end
end
