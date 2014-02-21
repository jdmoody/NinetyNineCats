class CatsController < ApplicationController
  before_filter :set_cat, only: [:show, :edit, :update, :destroy]
  before_action :verify_user, only: [:edit, :update]

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id
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

  def verify_user
    set_cat
    if @cat.user_id == current_user.id
      return true
    else
      flash[:errors] = ["You are not the owner of this cat!"]
      redirect_to cats_url
    end
  end
end
