class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "User Created Successfully. Welcome to Twitter Clone!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def index
  end
  
  def show
    @user = User.find(params[:id])
  end
end
