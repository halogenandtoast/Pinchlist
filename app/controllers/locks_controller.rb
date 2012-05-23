class LocksController < ApplicationController
  before_filter :authenticate_user!
  def update
    @list_proxy = current_user.list_proxies.find(params[:list_id])
    @list_proxy.toggle_public
    render json: {status: :ok}
  end
end
