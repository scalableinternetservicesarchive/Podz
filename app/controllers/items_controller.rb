class ItemsController < ApplicationController
  before_action :set_item,        only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user,  only: [:new, :create, :update, :destroy, :edit]
  before_action :user_owns_item,  only: [:edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    @category = params[:category_search]
    @keyword  = params[:keyword_search]

    @items = Item
    if !@category.nil? && @category.length.positive?
      @items = @items.where('category_id == ?', @category.to_i)
    end

    if !@keyword.nil? && @keyword.length.positive?
      @items = @items.where('LOWER(title) LIKE :keyword OR LOWER(description) LIKE :keyword', { keyword: "%#{@keyword.downcase}%" })
    end

    unless current_user.nil?
      @items = @items.where('user_id != ?', current_user.id)
    end

    @items_free = @items.where('available == TRUE').paginate(per_page: 20, page: params[:page])
    @items_rented = @items.where('available == FALSE').paginate(per_page: 20, page: params[:page])
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @reviews = Review.select { |review| review.item_id == @item.id }
    @review = Review.new(item_id: @item.id)
    @ratingSum = 0.0
    @reviews.each do |review|
      @ratingSum = @ratingSum + review.rating
    end
    @avgRating = (@ratingSum/@reviews.count).round(1)
    if logged_in?
      @isPrevRented = Rental.find_by(user_id: current_user.id, history: true, item_id: params[:id])
      @isPrevReviewed = Review.find_by(user_id: current_user, item_id: params[:id])
    end
    @rentals = Rental.where(item_id: params[:id], history: true)
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
    @item.condition = params[:condition]
    @item.latitude = params[:user_lat]
    @item.longitude = params[:user_lng]

      if @item.save
        flash[:success] = "Item created"
        redirect_to item_path(@item)
      else
        flash[:danger] = "Failed"
        render 'items/new'
      end

  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    if @item.update(item_params)
      flash[:success] = "Updated item"
      redirect_to item_path(@item)
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

  def user_owns_item
    redirect_to root_path unless current_user?(@item.user)
  end
end
