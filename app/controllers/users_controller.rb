class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    if logged_in?
      redirect_to cats_url
    else
      @user = User.new()
      render :new
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login!(@user)
      redirect_to cats_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
