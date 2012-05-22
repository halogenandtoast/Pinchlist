class Admin::DashboardsController < Admin::BaseController
  def show
    @user_count = User.count
    @permanent_count = User.where(status: "permanent").count
    @free_count = User.where(status: "inactive").count
    @paid_count = User.where(status: "active").count
    @list_count = List.count
    @proxy_count = ListProxy.count
  end
end
