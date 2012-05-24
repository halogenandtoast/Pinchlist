class DiscussionEvent < ActiveRecord::Base
  belongs_to :response, polymorphic: true, dependent: :destroy
  belongs_to :discussion
  belongs_to :user
  validates_associated :response

  def self.in_order
    order("created_at ASC")
  end
end
