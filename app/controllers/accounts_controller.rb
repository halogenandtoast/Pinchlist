class AccountsController < ApplicationController
  def edit
  end

  def update
    if save_user
      sign_in current_user, bypass: true
      redirect_to edit_account_path, notice: "Updated account"
    else
      flash.now[:notice] = "Could not update your account."
      render :edit
    end
  end

  private
  def save_user
    if params[:user][:password]
      current_user.update_attributes(params[:user])
    else
      current_user.update_without_password(params[:user])
    end
  end
end
