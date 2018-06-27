class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :redirect_to_dashboard_if_signed_in

  private

  def redirect_to_dashboard_if_signed_in
    redirect_to dashboard_path if user_signed_in?
  end
end
