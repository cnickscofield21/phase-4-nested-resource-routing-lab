class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if (params[:user_id])
      items = User.find(params[:user_id]).items
    else
      items = Item.all
    end

    render json: items, include: :user, status: :ok
  end

  def show
    render json: Item.find(params[:id]), status: :ok
  end

  def create
    user = User.find(params[:user_id])
    item = user.items.create(item_params)
    render json: item, include: :user, status: :created
  end

  private
  def item_params
    params.permit(:name, :description, :price, :user_id)
  end

  def render_not_found_response(exception)
    render json: { error: "#{exception.model} not found" }, status: :not_found
  end
end
