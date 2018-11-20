class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user,  only: [:new, :create, :update, :destroy, :edit]
  before_action :user_owns_review,  only: [:update, :destroy]

  # GET /reviews
  # GET /reviews.json
  def index
    @reviews = Review.all
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    if logged_in?
      @review = Review.new
    else
      flash[:danger] = "Only authenticated users can create reviews"
      redirect_to login_path
    end
  end

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id

    if @review.save
      flash[:success] = "Added review"
      redirect_to Item.find(@review.item_id)
    else
      flash[:danger] = "Review failed"
      redirect_to Item.find(@review.item_id)
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    if @review.update(review_params)
      flash[:success] = "Upated review"
      redirect_to @current_user || root_path
    else
      flash[:danger] = "Review failed"
      render 'edit'
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    flash[:success] = "Review deleted"
    RatingsCalculatorJob.perform_later
    redirect_to @current_user || root_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:item_id, :title, :body, :rating, :user_id, :anonymous)
    end

    def user_owns_review
      redirect_to root_path unless current_user?(@review.user)
    end
end
