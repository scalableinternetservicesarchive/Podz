class StaticPagesController < ApplicationController
  def home
    @items = Item.joins(:top_item).includes(:top_item)
    @users = User.joins(:top_user).includes(:top_user)
  end

  def about
  end

  def login
  end
end
