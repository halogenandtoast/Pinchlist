class ReopenResponse < ActiveRecord::Base
  has_one :discussion_event, as: :response
  after_create :reopen_discussion

  private

  def close_discussion
    discussion_event.discussion.reopen
  end

end
