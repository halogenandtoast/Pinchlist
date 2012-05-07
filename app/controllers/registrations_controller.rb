class RegistrationsController < Devise::RegistrationsController
  def update
    if current_user.update_without_password(params[:user])
      sign_in current_user, bypass: true
      redirect_to edit_user_registration_path, notice: "Updated account"
    else
      render :edit
    end
  end
end
