class CatRentalRequestsController < ApplicationController
  before_filter :set_cat_rental_request, only: [:show, :update, :destroy]

  def new
    @cats = Cat.all
    @cat_rental_request = CatRentalRequest.new()
    render :new
  end

  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)
    if @cat_rental_request.save
      redirect_to cat_url(Cat.find(@cat_rental_request.cat_id))
    else
      @cats = Cat.all
      flash.now[:errors] = @cat_rental_request.errors.full_messages
      render :new
    end
  end

  def approve
    @cat_rental_request = CatRentalRequest.find(params[:cat_rental_request_id])
    @cat_rental_request.approve!
    @cat = @cat_rental_request.cat
    redirect_to cat_url(@cat)
  end

  def deny
    @cat_rental_request = CatRentalRequest.find(params[:cat_rental_request_id])
    @cat = @cat_rental_request.cat
    @cat_rental_request.deny!
    redirect_to cat_url(@cat)
  end

  private
  def set_cat_rental_request
    @cat_rental_request = CatRentalRequest.find(params[:id])
  end

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date, :status)
  end
end
