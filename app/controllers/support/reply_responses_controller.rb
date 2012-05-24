class Support::ReplyResponsesController < Support::BaseController
  def create
    @discussion = Discussion.find(params[:discussion_id])
    @reply = ReplyResponse.new(params[:reply_response])
    @discussion_event = DiscussionEvent.new(response: @reply, discussion: @discussion)
    if signed_in?
      @reply.email = current_user.email
      @discussion_event.user = current_user
    end
    if @discussion_event.save
      redirect_to [:support, @discussion]
    else
      redirect_to [:support, @discussion]
    end
  end
end
