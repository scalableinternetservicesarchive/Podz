class StaticPagesController < ApplicationController
  def home
    @items = get_top_items
    @users = get_top_users
  end

  def about
  end

  def login
  end
end
