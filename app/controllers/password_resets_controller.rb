class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user, :check_expiration,
    only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_mail
      flash[:success] = t "success.send_mail_reset"
      redirect_to login_url
    else
      flash[:danger] = t "error.send_mail_reset"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t("warning.pass_empty")
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      @user.update_attributes reset_digest: nil
      flash[:success] = t "success.password_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private
  def find_user
    @user = User.find_by email: params[:email]
    return if @user
    flash[:danger] = t "error.find_user"
    redirect_to root_url
  end

  def valid_user
    redirect_to root_url unless
      @user&.activated? && @user.authenticated?(:reset, params[:id])
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "error.expired"
    redirect_to new_password_reset_url
  end
end
