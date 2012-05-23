class Public::ListsController < ApplicationController
  layout "public"
  def show
    @list_proxy = ListProxy.public_from_params(params)
  end
end
