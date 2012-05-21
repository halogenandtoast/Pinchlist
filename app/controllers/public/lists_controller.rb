class Public::ListsController < ApplicationController
  layout "public"
  def show
    @list_proxy = ListProxy.find_by_public_token(params[:id])
  end
end
