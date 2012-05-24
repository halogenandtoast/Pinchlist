class CloseResponse < ActiveRecord::Base
  has_one :discussion_event, as: :response
  after_create :close_discussion

  private

  def close_discussion
    discussion_event.discussion.close
  end

end
