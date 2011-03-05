class SharesController < ApplicationController
  def create
    @list = current_user.lists.find(params[:list_id])
    if @user = User.find_by_email!(params[:share_email])
      MemberMailer.share_list_email(:user => @user, :list => @list).deliver
    else @user = User.invite_without_email!(:email => params[:share_email])
      MemberMailer.share_list_and_invite_email(:user => @user, :list => @list).deliver
    end
    @list.proxies.create(:user => @user)
  end
end
