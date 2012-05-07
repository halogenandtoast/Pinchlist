class AccountsController < ApplicationController
  def edit
  end

  def update
    if current_user.update_without_password(params[:user])
      sign_in current_user, bypass: true
      redirect_to edit_account_path, notice: "Updated account"
    else
      render :edit
    end
  end
end
