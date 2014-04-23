class Api::BaseController < ApplicationController
  before_filter :authenticate_user!

  private

  def authenticate_user!
    if params[:token]
      token = AuthToken.new(params[:token])
      unless token.valid?
        render :json, status: :unauthorized
      end
    else
      super
    end
  end
end
