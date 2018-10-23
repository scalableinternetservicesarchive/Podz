class ItemsController < ApplicationController
  before_action :set_item,        only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user,  only: [:new, :create, :update, :destroy, :edit]

  # GET /items
  # GET /items.json
  def index
    @items = if params[:test_var] != nil
               Item.select { |item| item.title.downcase.include? params[:test_var].downcase }
             else
               Item.all
             end

    @items_free   = @items.select { |item| item.available == true; item.user_id != current_user.id}

    @items_rented = if params[:show_all] == 'true'
                      @items.select { |item| item.available == false}
                    else
                      {}
                    end

    @items_free   = @items_free.sort_by { |item| item.title.downcase }
    @items_rented = @items_rented.sort_by { |item| item.title.downcase }

  end

  # GET /items/1
  # GET /items/1.json
  def show
    @reviews = Review.select { |review| review.item_id == @item.id }
    @review = Review.new(item_id: @item.id)
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @category = Category.find_by(name: params[:category_id])
    @item = Item.new(item_params)
    @item.category_id = params[:item][:category_id]
    @item.available = true
    @item.user_id = @current_user.id

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    if @item.update(item_params)
      flash[:success] = "Updated item"
      redirect_to @item
    else
      render 'items/edit'
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    flash[:success] = "Item successfully destroyed"
    redirect_to items_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_params
    params.require(:item).permit(:title, :description, :available, :price_hourly_usd, :price_daily_usd)
  end
end
