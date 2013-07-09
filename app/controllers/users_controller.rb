class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user, only: :destroy

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
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Your Profile Was Updated Successfully"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "The User Was Successfully Removed"
    redirect_to users_url
  end

  private

    def signed_in_user
      unless signed_in?
        store_location
        flash[:info] = "You must be signed in to access this page."
        redirect_to signin_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:info] = "You are not authorized to access this page."
        redirect_to(root_path)
      end
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
