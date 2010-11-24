class ListsController < ApplicationController
  before_filter :authenticate_user!
  

  def create
    @list = current_user.lists.build(params[:list])
    respond_to do |format|
      if @list.save
        format.js { render }
        format.html { redirect_to dashboard_path, :notice => 'List created.' }
      else
        format.js { render }
        format.html { render 'dashboards/show' }
      end
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

  def show
    @list = List.find(params[:id])
  end

end
