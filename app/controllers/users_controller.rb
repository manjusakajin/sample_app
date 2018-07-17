class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update]
  before_action :logged_in_user, except: [:new, :create]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.select_user.page(params[:page]).per Settings.paginate.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:notice] = t "check_active"
      redirect_to root_url
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "success.update"
      redirect_to @user
      return
    end
    flash.now[:danger] = t "error.update"
    render :edit
  end

  def destroy
    if @user.destroy
      flash[:success] = t "success.delete"
    else
      flash[:danger] = t "error.delete"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def find_user
    @user = User.find_by id: params[:id]
    flash[:danger] = t "error.find_user" unless @user
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "warning.login"
    redirect_to login_url
  end

  def correct_user
    find_user

    return if @user.is_user? current_user
    flash[:danger] = t "error.wrong_user"
    redirect_to root_url
  end

  def check_admin
    return if @user.is_admin
    flash[:danger] = t "error.delete"
  end
end
