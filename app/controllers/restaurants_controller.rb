class RestaurantsController < ApplicationController
  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy]

  def index
    @restaurants = RestaurantsList.search(
      name: params[:search_name],
      city: params[:search_city],
      category: params[:search_category]
    )

    @restaurants.each do |restaurant|
      restaurant.image_base64 = Base64.encode64(restaurant.image) if restaurant.image.present?
    end
  end

  def show
    @restaurant = RestaurantsList.find(params[:id])
  end

  def new
    @restaurant = RestaurantsList.new
  end

  def create
    @restaurant = RestaurantsList.new(restaurant_params)
    if @restaurant.save
      save_image
      redirect_to restaurants_path, notice: "Restaurant added successfully!"
    else
      render :new
    end
  end

  def edit
    @restaurant = RestaurantsList.find(params[:id])
  end

  def update
    @restaurant = RestaurantsList.find(params[:id])

    if @restaurant.update(restaurant_params)
      save_image
      redirect_to restaurants_path, notice: "Restaurant updated successfully!"
    else
      render :edit
    end
  end

  def destroy
    @restaurant = RestaurantsList.find(params[:id])
    @restaurant.destroy
    redirect_to restaurants_path, notice: "Restaurant deleted successfully!"
  end

  private

  def restaurant_params
    params.require(:restaurants_list).permit(:name, :category, :description, :city, :address, :image)
  end

  def save_image
    image_data = params[:restaurants_list][:image]
    if image_data.present?
      new_image_data = image_data.read
      @restaurant.image = new_image_data
      @restaurant.save
    end
  end

  def require_admin
    unless Current.user&.admin?
      flash[:alert] = "You don't have permission to access this page."
      redirect_to restaurants_path
    end
  end
end
