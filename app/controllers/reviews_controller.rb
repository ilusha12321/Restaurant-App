class ReviewsController < ApplicationController
  before_action :require_user_logged_in!, except: [:index]
  before_action :require_user_profile, only: [:create]
  before_action :set_review, only: [:destroy]
  before_action :set_restaurant, only: [:index, :new, :create]

  def index
    @reviews = @restaurant.reviews
  end

  def new
    @review = @restaurant.reviews.new
  end

  def create
    @review = @restaurant.reviews.new(review_params)
    @review.user_id = Current.user.id

    if @review.save
      flash[:success] = 'Відгук успішно створено!'
      redirect_to restaurant_reviews_path(@restaurant)
    else
      flash.now[:alert] = 'Помилка при створенні відгуку'
      render :new
    end
  end

  def destroy
    if @review.destroy
      flash[:success] = 'Відгук успішно видалено!'
    else
      flash[:alert] = 'Помилка при видаленні відгуку'
    end
    redirect_to restaurant_reviews_path(@review.restaurant)
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def set_restaurant
    @restaurant = RestaurantsList.find(params[:restaurant_id])
  end

  def require_user_profile
    unless Current.user.user_profile.present?
      redirect_to profile_edit_path, alert: "Please fill in your profile before placing an order."
    end
  end

  def review_params
    params.require(:review).permit(:review_text, :rating)
  end
end
