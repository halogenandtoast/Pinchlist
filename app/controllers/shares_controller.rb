class SharesController < ApplicationController
  def create
    @list = current_user.owned_lists.find(params[:list_id])
    share = Share.new(params[:share].merge(list_id: params[:list_id], current_user_id: current_user.id))
    if share.save
      @user = share.user
    else
      render nothing: true
    end
  end

  def destroy
    @list = current_user.owned_lists.find(params[:list_id])
    @user = User.find_by_email(params[:email])
    @list.proxies.find_by_user_id(@user.id).destroy
    respond_to do |format|
      format.js
    end
  end
end
