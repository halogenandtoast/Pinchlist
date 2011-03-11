class SharesController < ApplicationController
  def create
    @list = current_user.lists.find(params[:list_id])
    share = Share.create(params[:share].merge(:list_id => params[:list_id]))
    share.save
    @user = share.user
  end
end
