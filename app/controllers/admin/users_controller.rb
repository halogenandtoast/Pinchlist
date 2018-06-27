class Admin::UsersController < Admin::BaseController
  before_action :authenticate_user!

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
end
