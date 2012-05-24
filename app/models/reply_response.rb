class ReplyResponse < ActiveRecord::Base
  has_one :discussion_event, as: :response
  has_one :discussion, through: :discussion_event
  validates :email, presence: true
  after_commit :increment_reply_count
  after_destroy :decrement_reply_count

  private

  def increment_reply_count
    discussion.increment!(:reply_count)
  end

  def decrement_reply_count
    discussion.decrement!(:reply_count)
  end

end
