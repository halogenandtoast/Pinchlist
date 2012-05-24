class Support::DiscussionsController < Support::BaseController
  before_filter :ensure_privacy, only: [:show]
  def index
    @categories = DiscussionCategory.all
  end

  def new
    @discussion = Discussion.new
  end

  def create
    @discussion = Discussion.new(params[:discussion])
    if signed_in?
      @discussion.user = current_user
    end
    if @discussion.save
      redirect_to [:support, @discussion]
    else
      render :new
    end
  end

  def show
    @discussion = Discussion.find(params[:id])
    @reply = ReplyResponse.new
    @events = @discussion.events.in_order
  end

  private
  def ensure_privacy
    unless current_user.try(:admin?)
      @discussion = Discussion.find(params[:id])
      if @discussion.private? && @discussion.user != current_user
        redirect_to support_path
      end
    end
  end
end
