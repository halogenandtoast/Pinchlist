class Public::ListsController < ApplicationController
  layout "public"
  def show
    @list = List.public_from_params(params)
  end
end
