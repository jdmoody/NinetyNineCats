class CatsController < ApplicationController
  before_filter :set_cat, only: [:show, :edit, :update, :destroy]


  def create
    @cat = Cat.new(cat_params)
    if @cat.save
      redirect_to cats_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    render :edit
  end

  def index
    @cats = Cat.all
    render :index
  end

  def new
    @cat = Cat.new()
    render :new
  end

  def show
    @rental_requests = @cat.cat_rental_requests.order(:start_date)
    render :show
  end

  def update
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private
  def set_cat
    @cat = Cat.find(params[:id])
  end

  def cat_params
    params.require(:cat).permit(:age, :color, :sex, :birth_date, :name)
  end
end
