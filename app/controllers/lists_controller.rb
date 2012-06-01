class ListsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @list = List.new(params[:list].merge(user: current_user))
    respond_to do |format|
      if @list.save
        format.js { render }
        format.html { redirect_to dashboard_path, notice: 'List created.' }
      else
        format.js { render "errors" }
        format.html { render 'dashboards/show' }
      end
    end
  end

  def update
    @list = current_user.lists.find(params[:id])
    @list.update_attributes(params[:list])
    respond_to do |format|
      format.js { render json: @list }
    end
  end

  def destroy
    list = current_user.lists.find(params[:id])
    list.destroy
    redirect_to dashboard_path, notice: 'List deleted.'
  end

  def show
    @list = current_user.lists.find(params[:id])
    @tasks = @list.tasks.by_position
  end
end
