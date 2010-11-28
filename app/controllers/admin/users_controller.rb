class Admin::UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.invite!(params[:user])
    redirect_to admin_users_path, :notice => "Invite sent"
  end

  protected

  def require_admin
    redirect_to root_path unless current_user.admin?
  end
end
