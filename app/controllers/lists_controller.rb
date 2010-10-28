class ListsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @list = current_user.lists.build(params[:list])
    if @list.save
      redirect_to dashboard_path, :notice => 'List created.'
    else
      render 'dashboards/show'
    end
  end

  def update
    @list = current_user.lists.find(params[:id])
    @list.update_attributes(params[:list])
    respond_to do |format|
      format.js { render :json => @list }
    end
  end

  def destroy
    list = current_user.lists.find(params[:id])
    list.destroy
    redirect_to dashboard_path, :notice => 'List deleted.'
  end
end
