class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
    cart_ids = $redis.smembers current_user_cart
    @cart_movies = Movie.find(cart_ids)
  end

  def add
    $redis.sadd current_user_cart, params[:movie_id]
    render json: current_user.cart_count, status: 200
  end

  def remove
    $redis.srem current_user_cart, params[:movie_id]
    render json: current_user.cart_count, status: 200
  end

  def cart_action(current_user_id)
    if $redis.sismember "cart#{current_user_id}", id
      "Remove from"
    else
      "Add to"
    end
  end

  private

  def current_user_cart
    "cart#{current_user.id}"
  end
end
