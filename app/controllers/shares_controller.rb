class SharesController < ApplicationController
  def create
    @user = User.find_by_email!(params[:share_email])
    @list = current_user.lists.find(params[:list_id])
    @list.proxies.create(:user => @user)
    MemberMailer.share_list_email(:user => @user, :list => @list).deliver
  end
end
