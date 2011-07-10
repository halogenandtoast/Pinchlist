class ListProxiesController < ApplicationController
  def update
    @list_proxy = current_user.proxy_for(params[:list_id])
    @list_proxy.update_attributes(params[:list_proxy])
    respond_to do |format|
      format.js { render :json => @list_proxy.list }
    end
  end

  def destroy
    @list_proxy = current_user.proxy_for(params[:list_id])
    @list_proxy.destroy
    redirect_to dashboard_path, :notice => 'List deleted.'
  end

  def show
    @list_proxy = current_user.proxy_for(params[:list_id])
    @tasks = @list_proxy.tasks.by_position
  end
end
