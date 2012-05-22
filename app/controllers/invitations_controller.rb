class InvitationsController < ApplicationController
  def create
    if User.where(email: params[:user][:email]).exists?
      redirect_to dashboard_path, :alert => "User already exists"
    else
      @user = User.invite!(params[:user])
      redirect_to dashboard_path, :notice => "Invite sent"
    end
  end
end
