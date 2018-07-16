class SessionsController < ApplicationController
  before_action :find_user, only: :create

  def new; end

  def create
    unless @user&.authenticate(params[:session][:password])
      flash.now[:danger] = t "error.login"
      render :new
      return
    end
    log_in @user
    params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
    redirect_back_or @user
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
  def find_user
    @user = User.find_by email: params[:session][:email].downcase
    flash.now[:danger] = t "error.find_user" unless @user
    render :new unless @user
  end
end
