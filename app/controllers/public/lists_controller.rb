class Public::ListsController < ApplicationController
  layout "public"
  skip_before_filter :authenticate_user!

  def show
    @list = List.public_from_params(params)
  end
end
