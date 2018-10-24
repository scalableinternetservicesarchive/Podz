class StaticPagesController < ApplicationController
  def home
    @items = get_top_items
  end

  def about
  end

  def login
  end
end
