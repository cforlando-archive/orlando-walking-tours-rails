class ToursController < ApplicationController

  before_action :authenticate_user!
  before_action :find_or_create_tour

  def show
    render json: @tour
  end

  def update
    @tour.update_attributes(tour_params)
    render json: @tour
  end

  private

  def tour_params
    params.require(:tour).permit(:data)
  end

  def find_or_create_tour
    @tour = Tour.where(user_id: current_user.id).first_or_create(name: 'Default Tour')
  end
end
